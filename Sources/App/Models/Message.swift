//
//  Message.swift
//
//
//  Created by Pedro Victor Furtado Sousa on 29/08/24.
//

import Vapor
import Fluent

final class Message: Model, Content{
    static let schema = "messages"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "text")
    var text: String
    
    @Parent(key: "chat_id")
    var chat: Chat
    
    init(){}
    
    init(id: UUID? = nil, text: String, chatId: Chat.IDValue){
        self.id = id
        self.text = text
        self.$chat.id = chatId
    }
}
