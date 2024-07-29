//
//  CustomMessage.swift
//  Project1
//
//  Created by BBC on 2024/5/17.
//

import Foundation
import AVFoundation

struct CustomMessage : Identifiable, Codable {
    let id: UUID
    var message: String?
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
    
    
    func convertDataSizeToMB(dataSize: Int) -> Double {
        let byteCount = Double(dataSize)
        let megabyte = 1024 * 1024
        let megabyteCount = byteCount / Double(megabyte)
        return megabyteCount
    }
    
    func getAudioFileDuration() -> Int {
        if let audioMessageURL = messageLocalURL {
            let audioPlayer = try? AVAudioPlayer(contentsOf: audioMessageURL)
            let duration : Int = Int(audioPlayer?.duration ?? 0)
            return duration
        }
        return 0
    }
    
    func calculateDataSizeInMB(data: Data) -> Double {
        let byteCount = Double(data.count)
        let megabyte = 1024 * 1024
        let megabyteCount = byteCount / Double(megabyte)
        return megabyteCount
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}


