<a name="readme-top"></a>


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Usage

In the previous tutorial, we use the PRESENCE (USER STATES) to save and publish the user profile data. There are 2 issues with this: once user logs out, the PRESENCE (USER STATES) will be wiped. Second, you can only see online users. In this tutorial, we will use STORAGE (USER METADATA) feature to permanently store the user profile data. You can use this feature to add contact as friend and save their profile. 


| Subscribe features | Description |
| --- | --- |
| `.message` | Callback to receive all messages of a subscribed channel |
| `.presence` | Callback to get the users states (e.g join/leave/userstates) of a channel |



<!-- Sample Code -->
## Sample Code

****Store the PRESENCE USER STATES to STORAGE USER METADATA****
```swift

// You can use this code to save USER/CONTACT to your STORAGE USER METADATA
// When you add user as friend, call this function. 
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
                // Success
            }else{
                // Failed
            }
        }
    }
}
```

****Remove STORAGE USER METADATA****
```swift
// You can use this code to remove USER/CONTACT from your STORAGE USER METADATA
// When you remove a user as a friend, call this function
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
         // Success
        }else{
        // Failed
        }
    }
}
```


****Fetch all your STORAGE USER METADATA (AKA YOUR FRIENDS LIST)**** 
```swift
// You can use this code to remove USER/CONTACT from your STORAGE USER METADATA
@MainActor
func fetchAllStorageContacts() async -> Bool{
    if let (response, error) = await agoraRtmKit?.getStorage()?.getUserMetadata(userId: userID) {
        if error == nil {
            for key in response?.data?.getItems() ?? [] {
                if let savedContact = convertJSONStringToOBJECT(jsonString: key.value, objectType: Contact.self) {
                    // Loop through each contact and add it to your friendlist
                    // Once you fetched your own profile, you can call set your PRESENCE USER DATA to notify users. 
                }
            }
            return true
        }
    }
    return false
}
```




**Setup RTM Presence Callback**
```swift
// Here is where you handle 
// Receive 'presence' event notifications in subscribed message channels and joined stream channels.
func rtmKit(_ rtmKit: AgoraRtmClientKit, didReceivePresenceEvent event: AgoraRtmPresenceEvent) {

    if event.type == .remoteLeaveChannel || event.type == .remoteConnectionTimeout {
    // A remote user left the channel e.g. event.publisher is offline
    // If it's a friend, set friends status as offline
    // If it's not a friend, remove user from list
        
    }else if event.type == .remoteJoinChannel && event.publisher != nil {
     // A remote user subscribe the channel e.g. event.publisher is online
    // If it's a friend, set friends status as online
    // If it's not a friend, add user to list
        
    }else if event.type == .snapshot {
    // Get a snapshot of all the online users states (aka their profile data)
    // This triggers once when you first subscribed. Use this to fill up your friend list 
        
        // Loop through each event aka user data
        for event in event.snapshot {

            // UserID                    ---> event.userId
            // All User States           ---> event.states
            // Specific User State value ---> event.states.first(where: {$0.key == customDefinedKey})?.value
            // customListOfUsers.append(newUser)

        }
    }else if event.type == .remoteStateChanged {
    // A remote user's 'presence' data was changed (when user changed their profile)

        // UserID  ---> event.publisher
        // New User States ---> event.states
    }
}
```

**Logout RTM**
```swift
// Logout RTM server
func logoutRTM(){
    agoraRtmKit?.logout()
    agoraRtmKit?.destroy()
}
```



<!-- RTM API Limitation -->
## References

- API Reference (https://docs.agora.io/en/signaling/reference/api?platform=ios)
- Pricing (https://docs.agora.io/en/signaling/overview/pricing?platform=ios)
- API Limitations (https://docs.agora.io/en/signaling/reference/limitations?platform=android)
- Security/Compliance (https://docs.agora.io/en/signaling/reference/security?platform=android) 



<p align="right">(<a href="#readme-top">back to top</a>)</p>





<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Bac Huang  - bac@boldbright.studio

Project Link: [https://github.com/Bac1314/APIExample_AgoraRTM2x](https://github.com/Bac1314/APIExample_AgoraRTM2x)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



