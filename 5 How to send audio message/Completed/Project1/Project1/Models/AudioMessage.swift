//
//  AudioMessage.swift
//  Project1
//
//  Created by BBC on 2024/6/6.
//

import Foundation


struct AudioMessage : Identifiable, Codable {
    var id: UUID
    var fileName: String
    var fileURL: URL
    var sender: String
    var duration: Int // In Seconds
}
