//
//  AgoraRTMViewModel.swift
//  Project1
//
//  Created by BBC on 2024/5/9.
//

import Foundation
import SwiftUI
import AgoraRtmKit

class AgoraRTMViewModel: NSObject, ObservableObject {
    var agoraRtmKit: AgoraRtmClientKit? = nil
    @AppStorage("userID") var userID: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var listOfContacts : [Contact] = []
    
    let rootChannel: String = "rootChannel"
    let contactKey: String = "contactKey"
    
    // MARK: Login to Agora Server
    func loginRTM() async throws {
        do {
            if userID.isEmpty {
                throw customError.emptyUIDLoginError
            }
            
            // Initialize Agora RTM SDK
            if agoraRtmKit == nil {
                let config = AgoraRtmClientConfig(appId: Configurations.agora_AppdID , userId: userID)
                agoraRtmKit = try AgoraRtmClientKit(config, delegate: self)
            }
            
            // Generate a token (If project didn't enable app certificate, you can use appID to login)
            let token = Configurations.agora_AppdID
            
            // Login to RTM server
            if let (_, error) = await agoraRtmKit?.login(token) {
                if error == nil{
                    await MainActor.run {
                        isLoggedIn = true
                    }
                    let _ = await subscribeMainChannel()
                    
                }else{
                    await agoraRtmKit?.logout()
                    throw error ?? customError.loginRTMError
                }
            } else {
                throw customError.loginRTMError
   
            }
            
        }catch {
            print("Bac's Some other error occurred: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: Logout RTM server
    func logoutRTM(){
        agoraRtmKit?.logout()
        agoraRtmKit?.destroy()
        agoraRtmKit = nil
        isLoggedIn = false
        listOfContacts.removeAll()
    }
    
    // MARK: Subscribe to one main channel to receive user online status
    func subscribeMainChannel() async -> Bool {
        let subOptions: AgoraRtmSubscribeOptions = AgoraRtmSubscribeOptions()
        subOptions.features =  [.presence]
        
        if let (_, error) = await agoraRtmKit?.subscribe(channelName: rootChannel, option: subOptions){
            if error == nil {
                //subscribe success
                return true
            }else {
                //subscribe failed
            }
            return false
        }
        return false
    }
    
    
    
    // MARK: Save Contact to Presence
    func saveContact() async -> Bool {
        
        if let jsonString = convertOBJECTtoJSONString(object: listOfContacts.first(where: {$0.userID == userID})) {
            // Setup Agora Presence Item
            let item = AgoraRtmStateItem()
            item.key = contactKey
            item.value = jsonString
            
            // Update and publish contact info
            if let (_, error) = await agoraRtmKit?.getPresence()?.setState(channelName: rootChannel, channelType: .message, items: [item]){
                if error == nil {
                    return true
                }
            }
        }
        
        return false
    }
}

// Agora RTM Callbacks
extension AgoraRTMViewModel: AgoraRtmClientDelegate {
    // Receive presence event notifications in subscribed message channels and joined stream channels.
    func rtmKit(_ rtmKit: AgoraRtmClientKit, didReceivePresenceEvent event: AgoraRtmPresenceEvent) {
        if event.type == .remoteLeaveChannel || event.type == .remoteConnectionTimeout {
            // A remote user left the channel
            if let userIndex = listOfContacts.firstIndex(where: {$0.userID == event.publisher}) {
                listOfContacts.remove(at: userIndex)
            }
        }else if event.type == .remoteJoinChannel && event.publisher != nil {
            // A remote user join/subscribe the channel
            
            if !listOfContacts.contains(where: {$0.userID == event.publisher}) && event.publisher != nil {
                let newContact = Contact(userID: event.publisher!)
                listOfContacts.append(newContact)
            }
            
        }else if event.type == .snapshot {
            // Get a snapshot of all the subscribed users' 'presence' data (aka temporary profile key-value pairs)
            // Add users to list from snapshop
            for event in event.snapshot {
                
                // Create default contact
                var newContact = Contact(userID: event.userId)
                

                // Check if user contact info exists on RTM PRESENCE storage
                if let newContactJSONString = event.states.first(where: {$0.key == contactKey})?.value {
                    if let newContactDetails = convertJSONStringToOBJECT(jsonString: newContactJSONString, objectType: Contact.self) {
                        newContact = newContactDetails
                    }
                }
                
                // Add to list
                listOfContacts.append(newContact)
                
                /*
                 
                 */

            }
            
            
        }else if event.type == .remoteStateChanged {
            // A remote user's 'presence' data was changed aka user edited their profile key-value pairs
            if let userIndex = listOfContacts.firstIndex(where: {$0.userID == event.publisher}), let newContactJSONString = event.states.first(where: {$0.key == contactKey})?.value, let publisher = event.publisher{
                listOfContacts[userIndex] = convertJSONStringToOBJECT(jsonString: newContactJSONString, objectType: Contact.self) ?? Contact(userID: publisher, name: publisher)
            }
        }
        
    }
}
