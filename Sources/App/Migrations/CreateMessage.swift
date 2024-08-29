//
//  CreateMessage.swift
//  
//
//  Created by Pedro Victor Furtado Sousa on 29/08/24.
//

import Fluent

struct CreateMessage: Migration {
    func prepare(on database: Database ) -> EventLoopFuture<Void>{
        return database.schema("messages")
            .id()
            .field("text", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void>{
        return database.schema("messages").delete()
    }
}

