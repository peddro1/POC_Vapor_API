//
//  File.swift
//  
//
//  Created by Pedro Victor Furtado Sousa on 05/09/24.
//

import Fluent
import Vapor

struct ChatWithMessages: Content{
    var chat: Chat
    var messages: [MessageWithoutChat]
    
    init(chat: Chat, messages: [MessageWithoutChat]){
        self.chat = chat
        self.messages = messages
    }
    
}
