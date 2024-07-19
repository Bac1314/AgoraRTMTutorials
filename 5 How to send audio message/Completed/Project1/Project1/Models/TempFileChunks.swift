//
//  TempFileChunks.swift
//  Project1
//
//  Created by BBC on 2024/7/19.
//

import Foundation

struct TempFileChunks {
    let id: UUID
    let sender: String
    let fileCountof32KB: Int
    var chunks: [Data]
    
}
