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
}
