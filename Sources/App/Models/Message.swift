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
    
    init(){}
    
    init(id: UUID? = nil, text: String){
        self.id = id
        self.text = text
    }
}
