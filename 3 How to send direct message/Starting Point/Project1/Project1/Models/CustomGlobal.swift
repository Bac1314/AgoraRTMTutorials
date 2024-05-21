//
//  CustomGlobal.swift
//  Project1
//
//  Created by BBC on 2024/5/9.
//

import Foundation
import UIKit

enum customNavigateType : Hashable{
    case ContactDetailView(username: String)
}

enum customError: LocalizedError {
    case loginRTMError
    case emptyUIDLoginError

    var errorDescription: String? {
        switch self {
        case .loginRTMError:
            return NSLocalizedString("There was a problem logging in to RTM", comment: "Login RTM Error")
        case .emptyUIDLoginError:
            return NSLocalizedString("UID is empty during login", comment: "Empty UID Login Error")
        }
    }
}

// Convert OBJECT to JSONSTRING
func convertOBJECTtoJSONString<T: Encodable>(object: T) -> String? {
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(object)
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch {
        print("Error encoding object into JSON, error: \(error.localizedDescription)")
    }
    
    return nil
}

// CONVERT JSONSTRING to OBJECT (e.g. CustomPoll)
func convertJSONStringToOBJECT<T: Decodable>(jsonString: String, objectType: T.Type) -> T? {
    let decoder = JSONDecoder()
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            let object = try decoder.decode(objectType, from: jsonData)
            return object
        } catch {
            print("Error decoding JSON into object, error: \(error.localizedDescription)")
        }
    }
    
    return nil
}
