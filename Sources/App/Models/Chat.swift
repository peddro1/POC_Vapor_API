//
//  Chat.swift
//
//
//  Created by Pedro Victor Furtado Sousa on 04/09/24.
//

import Vapor
import Fluent

final class Chat: Model, Content{
    static let schema = "chat"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "to_user")
    var toUser: String
    
    @Field(key: "from_user")
    var fromUser: String
    
    @Children(for: \.$chat)
    var messages: [Message]
    
    init(){}
    
    init(id: UUID, toUser: String, fromUser: String){
        self.id = id
        self.toUser = toUser
        self.fromUser = fromUser
    }
}
