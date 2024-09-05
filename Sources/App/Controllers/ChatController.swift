//
//  File.swift
//  
//
//  Created by Pedro Victor Furtado Sousa on 04/09/24.
//

import Fluent
import Vapor

struct ChatController: RouteCollection{
    func boot(routes: RoutesBuilder) throws{
        let chats = routes.grouped("chats")
        
        chats.get(use: index)
        chats.post(use: create)
        chats.put(use: update)
        chats.group(":chatID"){ chat in
            chat.delete(use: delete)
            chat.get(use: getChatById)
        }
    }
    
    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[Chat]>{
        return Chat.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let chat = try req.content.decode(Chat.self)
        return chat.save(on: req.db).transform(to: .ok)
    }
    
    @Sendable
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let chat = try req.content.decode(Chat.self)
        
        return Chat.find(chat.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.toUser = chat.toUser
                $0.fromUser = chat.fromUser
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        Chat.find(req.parameters.get("chatID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete( on: req.db)}
            .transform(to: .ok)
    }
    
    @Sendable
    func getChatById(req: Request) throws -> EventLoopFuture<ChatWithMessages>{
       
        guard let chatIDString = req.parameters.get("chatID"),
                  let chatID = UUID(chatIDString) else {
                throw Abort(.badRequest, reason: "Invalid chat ID")
            }
        
        return Chat.find(chatID, on: req.db)
                .unwrap(or: Abort(.notFound)) // Garante que o chat existe
                .flatMap { chat in
                    // Agora buscamos as mensagens associadas ao chat
                    return Message.query(on: req.db)
                        .filter(\.$chat.$id == chatID)
                        .all()
                        .map { messages in
                            // Quando tivermos o chat e as mensagens, retornamos o DTO
                            let messagesWithoutChat = messages.map { message in
                                return MessageWithoutChat(id: message.id!, text: message.text)
                            }
                            return ChatWithMessages(chat: chat, messages: messagesWithoutChat)
                        }
                }
    }
}
