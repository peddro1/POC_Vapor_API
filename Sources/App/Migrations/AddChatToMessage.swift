//
//  File.swift
//  
//
//  Created by Pedro Victor Furtado Sousa on 04/09/24.
//

import Fluent

struct AddChatToMessage: Migration{
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("messages")
            .field("chat_id", .uuid, .references("chat", "id"))
            .update()
        
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("messages")
            .deleteField("chat_id")
            .update()
    }
}
