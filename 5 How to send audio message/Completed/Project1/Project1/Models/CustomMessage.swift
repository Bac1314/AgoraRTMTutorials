//
//  CustomMessage.swift
//  Project1
//
//  Created by BBC on 2024/5/17.
//

import Foundation

struct CustomMessage : Identifiable, Codable {
    let id: UUID
    var message: String?
    var audioMessage: AudioMessage?
    var sender: String
    var receiver: String
    var lastUpdated: Date
    var fileName: String?
    var messageType: customMessageType = .text
    var messageLocalURL: URL?
    var messageSize: Int?
    var messageChunkCountIn32KB: Int?
//    var channelType:
//    var messageType:
    
}


