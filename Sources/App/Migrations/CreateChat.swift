//
//  CreateChat.swift
//
//
//  Created by Pedro Victor Furtado Sousa on 04/09/24.
//

import Fluent

struct CreateChat: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void>{
        return database.schema("chat")
            .id()
            .field("to_user", .string, .required)
            .field("from_user", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void>{
        return database.schema("chat").delete()
    }
}
