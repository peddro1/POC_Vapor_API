//
//  MessageController.swift
//
//
//  Created by Pedro Victor Furtado Sousa on 29/08/24.
//

import Fluent
import Vapor

struct MessageController: RouteCollection{
    func boot(routes: RoutesBuilder) throws{
        let messages = routes.grouped("messages")
        messages.get(use: index)
        messages.post( use: create)
        messages.put(use: update)
        messages.group(":messageID"){ message in
            message.delete(use: delete)
        }
    }
    
    // GET Request / mesaages route
    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[Message]>{
        return Message.query(on: req.db).all()
    }
    
    // Post Request / mesaages route
    @Sendable
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let message = try req.content.decode(Message.self)
        return message.save(on: req.db).transform(to: .ok)
    }
    
    // Update Request / mesaages route
    @Sendable
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let message = try req.content.decode(Message.self)
        
        return Message.find(message.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.text = message.text
                return $0.update(on: req.db).transform(to: .ok)
        }
    }
    
    // Delete Request / mesaages route
    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        Message.find(req.parameters.get("messageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{$0.delete(on: req.db)}
            .transform(to: .ok)
    }
}
