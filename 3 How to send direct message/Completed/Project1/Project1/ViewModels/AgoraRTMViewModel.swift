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
    @AppStorage("userAvatar") var userAvatar: String = "avatar_default" // Only used for displaying avatar on login page
    @Published var isLoggedIn: Bool = false
    @Published var listOfContacts : [Contact] = [] // Including friends and strangers (differentiate with the friend parameter
    @Published var friendList: [Contact] = []
    @Published var messages : [CustomMessage] = []
    
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
                    
                    let _ = await fetchAllStorageContacts() // Get your contact and friend contact info from storage usermetadata
                    if let _ = listOfContacts.firstIndex(where: {$0.userID == userID}) {
                        let _ = await setUserPresenceProfile(savetoStorage: false) // Set the userprofile from storage usermetadata to presence userstates
                    }
                    let _ = await subscribeMainChannel() // Subscribe to rootchannel to listen for presence callbacks
                    
                    try await loadMessagesFromLocalStorage() // Load messages from local database
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
        friendList.removeAll()
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
    
    // MARK: Save Contact to Presence storage (temporary data)
    // changed from saveContact --> setUserPresenceProfile
    func setUserPresenceProfile(savetoStorage: Bool = true) async -> Bool {
        if let currentUserContact = listOfContacts.first(where: {$0.userID == userID}) {
            
            await MainActor.run {
                userAvatar = currentUserContact.avatar // For display avatar on login only
            }
            
            if let jsonString = convertOBJECTtoJSONString(object: currentUserContact) {
                // Setup Agora Presence Item
                let item = AgoraRtmStateItem()
                item.key = contactKey
                item.value = jsonString
                
                // Update and publish contact info
                if let (_, error) = await agoraRtmKit?.getPresence()?.setState(channelName: rootChannel, channelType: .message, items: [item]){
                    if error == nil {
                        // Update the local user data to storage
                        if savetoStorage {
                            await saveContactToStorage(contact: currentUserContact)
                        }
                        return true
                    }
                }
            }
        }
        
        
        return false
    }
    
    // MARK: Save a single contact to STORAGE User Metadata (Permanent Data)
    func saveContactToStorage(contact: Contact) async {
        if let jsonString = convertOBJECTtoJSONString(object: contact) {
            // MARK: Setup Agora Metadata item
            guard let metaData: AgoraRtmMetadata = agoraRtmKit?.getStorage()?.createMetadata() else { return }
            
            let metaDataItem: AgoraRtmMetadataItem = AgoraRtmMetadataItem()
            metaDataItem.key = "\(contactKey)_\(contact.userID)" // e.g. key = contactKey_Bac
            metaDataItem.value = jsonString
            metaData.setMetadataItem(metaDataItem)
            
            // Metadata options
            let metaDataOption: AgoraRtmMetadataOptions = AgoraRtmMetadataOptions()
            metaDataOption.recordUserId = true
            metaDataOption.recordTs = true
            
            
            if let (_, error) = await agoraRtmKit?.getStorage()?.setUserMetadata(userId: userID, data: metaData, options: metaDataOption){
                if error == nil {
                    print("Save saveContactToStorage success \(jsonString)")
                }else{
                    // Save failed
                    print("Save saveContactToStorage failed \(jsonString)")
                    
                }
            }
        }
        
    }
    
    // MARK: Remove a single contact from STORAGE User Metadata
    func deleteContactFromStorage(contact: Contact) async {
        // MARK: Setup Agora Metadata item
        guard let metaData: AgoraRtmMetadata = agoraRtmKit?.getStorage()?.createMetadata() else { return }
        
        let metaDataItem: AgoraRtmMetadataItem = AgoraRtmMetadataItem()
        metaDataItem.key = "\(contactKey)_\(contact.userID)" // e.g. key = contactKey_Bac
        metaData.setMetadataItem(metaDataItem)
        
        // Metadata options
        let metaDataOption: AgoraRtmMetadataOptions = AgoraRtmMetadataOptions()
        metaDataOption.recordUserId = true
        metaDataOption.recordTs = true
        
        if let (_, error) = await agoraRtmKit?.getStorage()?.removeUserMetadata(userId: userID, data: metaData, options: metaDataOption){
            if error == nil {
                print("Save removeContactFromStorage success ")
            }else{
                // Save failed
                print("Save removeContactFromStorage failed ")
                
            }
        }
    }
    
    // MARK: Fetch all contacts from STORAGE User metadata
    @MainActor
    func fetchAllStorageContacts() async -> Bool{
        // Clear the list first
        listOfContacts.removeAll()
        friendList.removeAll()
        
        if let (response, error) = await agoraRtmKit?.getStorage()?.getUserMetadata(userId: userID) {
            if error == nil {
                for key in response?.data?.getItems() ?? [] {
                    if let savedContact = convertJSONStringToOBJECT(jsonString: key.value, objectType: Contact.self) {
                        var newSavedContact = savedContact
                        newSavedContact.online = newSavedContact.userID == userID ? true : false // all saved friends would be offline, we'll change it from the didReceivePresenceEvent callback
                        listOfContacts.append(newSavedContact)
                        if newSavedContact.userID != userID {
                            friendList.append(newSavedContact)
                            print("bac's friendlist \(friendList)")
                        }
                    }
                }
                return true
            }
        }
        return false
    }
    
    // MARK: Add friend
    func addAsFriend(contact: Contact){
        Task {
            await MainActor.run {
                if !friendList.contains(where: { $0.userID == contact.userID}) {
                    friendList.append(contact)
                }
            }
            await saveContactToStorage(contact: contact)
        }
    }
    
    // MARK: Remove friend
    func removeFriend(contact: Contact){
        Task {
            await MainActor.run {
                friendList.removeAll(where: {$0.userID == contact.userID})
            }
            await deleteContactFromStorage(contact: contact)
        }
    }
    
    
    // MARK: Publish message
    func publishToUser(userName: String, messageString: String, customType: String?) async -> Bool{
        let pubOptions = AgoraRtmPublishOptions()
        pubOptions.customType = customType ?? ""
        pubOptions.channelType = .user
        
        if let (_, error) = await agoraRtmKit?.publish(channelName: userName, message: messageString, option: pubOptions){
            if error == nil {
                // MARK: if success, create a local message event for display (bc callback doesn't fire for local send)
                await MainActor.run {
                    let customMessage = CustomMessage(id: UUID(), message: messageString, sender: userID, receiver: userName, lastUpdated: Date())
                    messages.append(customMessage)
                }
                try? await saveMessagesToLocalStorage(messages: messages)
                return true
            }else{
                print("Bac's sendMessageToChannel error \(String(describing: error))")
                return false
            }
            
        }
        return false
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("rtmMessages.data")
    }


    func loadMessagesFromLocalStorage() async throws {
        let task = Task<[CustomMessage], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let customMessages = try JSONDecoder().decode([CustomMessage].self, from: data)
            return customMessages
        }
        let loadedMessages = try await task.value
        
        Task {
            await MainActor.run {
                self.messages = loadedMessages
            }
        }
    }


    func saveMessagesToLocalStorage(messages: [CustomMessage]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(messages)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}

// Agora RTM Callbacks
extension AgoraRTMViewModel: AgoraRtmClientDelegate {
    // Receive presence event notifications in subscribed message channels and joined stream channels.
    func rtmKit(_ rtmKit: AgoraRtmClientKit, didReceivePresenceEvent event: AgoraRtmPresenceEvent) {
        if event.type == .remoteLeaveChannel || event.type == .remoteConnectionTimeout {
            // A remote user left the channel
            if let userIndex = listOfContacts.firstIndex(where: {$0.userID == event.publisher}) {
                if friendList.contains(where: { $0.userID == listOfContacts[userIndex].userID}) {
                    listOfContacts[userIndex].online = false
                }else {
                    listOfContacts.remove(at: userIndex)
                }
            }
        }else if event.type == .remoteJoinChannel && event.publisher != nil {
            // A remote user join/subscribe the channel
            // If user doesn't exist in list, add the contact, else update
            if let userIndex = listOfContacts.firstIndex(where: {$0.userID == event.publisher}){
                listOfContacts[userIndex].online = true
            }else {
                let newContact = Contact(userID: event.publisher!)
                listOfContacts.append(newContact)
            }
            
            
        }else if event.type == .snapshot {
            // Get a snapshot of all the subscribed users' 'presence' data (aka temporary profile key-value pairs)
            // Add users to list from snapshop
            print("Bac's snapshot ")
            for event in event.snapshot {
                // Check if user exists in the listOfContacts
                if let userIndex = listOfContacts.firstIndex(where: {$0.userID == event.userId}) {
                    // User exists, check if remote user updated their contact
                    //                    let newContact =  Contact(userID: event.userId, online: true)
                    if let newContactJSONString = event.states.first(where: {$0.key == contactKey})?.value {
                        if let newContactDetails = convertJSONStringToOBJECT(jsonString: newContactJSONString, objectType: Contact.self) {
                            let newContact = newContactDetails
                            
                            // Remote user updated their profile
                            if !newContact.isEqual(to: listOfContacts[userIndex]){
                                Task {
                                    await MainActor.run {
                                        listOfContacts[userIndex] = newContact
                                    }
                                    await saveContactToStorage(contact: newContact)
                                }
                            }
                            
                            
                        }
                    }
                    
                    listOfContacts[userIndex].online = true
                    
                }else {
                    // User doesn't exists, add to list
                    Task {
                        await MainActor.run {
                            var newContact =  Contact(userID: event.userId, online: true)
                            if let newContactJSONString = event.states.first(where: {$0.key == contactKey})?.value {
                                if let newContactDetails = convertJSONStringToOBJECT(jsonString: newContactJSONString, objectType: Contact.self) {
                                    newContact = newContactDetails
                                    newContact.online = true
                                }
                            }
                            listOfContacts.append(newContact)
                        }
                    }
                }
                
            }
            
        }else if event.type == .remoteStateChanged {
            // A remote user's 'presence' data was changed aka user edited their profile key-value pairs
            if let userIndex = listOfContacts.firstIndex(where: {$0.userID == event.publisher}), let newContactJSONString = event.states.first(where: {$0.key == contactKey})?.value, let publisher = event.publisher{
                listOfContacts[userIndex] = convertJSONStringToOBJECT(jsonString: newContactJSONString, objectType: Contact.self) ?? Contact(userID: publisher, name: publisher)
                
                // Check if it's friend
                if friendList.contains(where: { $0.userID == listOfContacts[userIndex].userID}) {
                    // Save new friend data to user metadata
                    Task {
                        await saveContactToStorage(contact: listOfContacts[userIndex])
                    }
                }
            }
        }
        
    }
    
    // Receive message event notifications in subscribed message channels and subscribed topics.
    func rtmKit(_ rtmKit: AgoraRtmClientKit, didReceiveMessageEvent event: AgoraRtmMessageEvent) {
   
        switch event.channelType {
        case .message:
            break
        case .stream:
            break
        case .user:
            Task {
                await MainActor.run {
                    withAnimation {
                        let customMessage = CustomMessage(id: UUID(), message: event.message.stringData ?? "", sender: event.publisher, receiver: userID, lastUpdated: Date())

                        messages.append(customMessage)

                        // Move Contact to the top
                        if let contactIndex = listOfContacts.firstIndex(where: {$0.userID == event.publisher}) {
                            let contact = listOfContacts.remove(at: contactIndex)
                            listOfContacts.insert(contact, at: 0)
                        }
                    }

                }
                try? await saveMessagesToLocalStorage(messages: messages)
            }
            break
        case .none:
            break
        @unknown default:
            print("Bac's didReceiveMessageEvent channelType is unknown")
        }
    }
}

