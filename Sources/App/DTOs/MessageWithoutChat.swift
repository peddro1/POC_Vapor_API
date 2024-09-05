//
//  File.swift
//  
//
//  Created by Pedro Victor Furtado Sousa on 05/09/24.
//

import Fluent
import Vapor

struct MessageWithoutChat: Content{
    let id: UUID
    let text: String
}
