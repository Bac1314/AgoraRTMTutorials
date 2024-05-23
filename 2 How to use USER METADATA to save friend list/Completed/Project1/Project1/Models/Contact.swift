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
    var online: Bool = false // to show if users are online or not
    
    // We use this to compare two objects for ContactDetailView saving action
    func isEqual(to other: Contact) -> Bool {
        return userID == other.userID &&
               name == other.name &&
               gender == other.gender &&
               company == other.company &&
               title == other.title &&
               description == other.description &&
               avatar == other.avatar
    }
    
    // We use this to filter the list of contacts
    func contains(searchText: String) -> Bool{
        return userID.lowercased().contains(searchText.lowercased()) || name.lowercased().contains(searchText.lowercased()) || company.lowercased().contains(searchText.lowercased())
    }
}

enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case transgender = "Transgender"
    case nonbinary = "Non-binary/non-conforming"
    case prefernoresponse = "Prefer not to response"
}

