//
//  Contact.swift
//  Project1
//
//  Created by BBC on 2024/5/10.
//

import Foundation

struct Contact: Codable {
//    var id = UUID() // System unique ID
    var userID: String // Agora Unique ID
    var name: String = ""
    var gender: Gender  = .prefernoresponse
    var company: String = ""
    var title: String = ""
    var description: String = ""
    var avatar: String  = "avatar_default"
}

enum Gender: String, Codable, CaseIterable {
    case male = "male"
    case female = "female"
    case transgender = "transgender"
    case nonbinary = "non-binary/non-conforming"
    case prefernoresponse = "prefer not to response"
}

