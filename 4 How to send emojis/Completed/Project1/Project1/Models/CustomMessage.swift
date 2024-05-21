//
//  CustomMessage.swift
//  Project1
//
//  Created by BBC on 2024/5/17.
//

import Foundation

struct CustomMessage : Identifiable, Codable {
    let id: UUID
    var message: String
    var sender: String
    var receiver: String
    var lastUpdated: Date
//    var channelType:
//    var messageType:
    
}


