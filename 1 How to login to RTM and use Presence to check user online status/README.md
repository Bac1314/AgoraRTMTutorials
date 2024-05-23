<a name="readme-top"></a>


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Usage

This tutorial will show how to login to Agora RTM server and how to use the `.presence` feature to show all users online state and profile

| Subscribe features | Description |
| --- | --- |
| `.message` | Callback to receive all messages of a subscribed channel |
| `.presence` | Callback to get the users states (e.g join/leave/userstates) of a channel |



<!-- Sample Code -->
## Sample Code

**Initialize the Agora RTM SDK**
```swift
// Initialize the Agora RTM SDK
let config = AgoraRtmClientConfig(appId: "your_app_id" , userId: "user_id")
var agoraRtmKit: AgoraRtmClientKit = try AgoraRtmClientKit(config, delegate: self)
```

**Login to Agora Server**
```swift
// Login to Agora Server
if let (response, error) = await agoraRtmKit?.login("user_token") {
    if error == nil{
       // Login successful
    }else{
      // Login failed
    }
} else {
    // Login failed
}
```

**Subscribe to a Root Channel to receive presence callback (User states)**
```swift
// Define the subscription feature
let subOptions: AgoraRtmSubscribeOptions = AgoraRtmSubscribeOptions()
subOptions.features =  [.presence]

// Subscribe to a channel  
if let (response, error) = await agoraRtmKit?.subscribe(channelName: rootChannelName, option: subOptions){
    if error == nil{
       // Subscribe successful
    }else{
      // Subscribe failed
    }
}
```

**Set your own PRESENCE user state (aka profile)**

```swift
// You can do it 2 ways


// A. Save all the user data into one user state
// e.g. Define your own Contact struct. Encode it to JSONString then send it as one user data
let jsonString =  "{"company":"Agora","description":"Random description","userID":"Bac","title":"TAM","gender":"Male","avatar":"avatar_default","name":"Bac Huang"}"

let item = AgoraRtmStateItem()
item.key = "customDefinedKey" // You can define anythin
item.value = jsonString

// Publish/Set your user state 
if let (response, error) = await agoraRtmKit?.getPresence()?.setState(channelName: rootChannel, channelType: .message, items: [item]){
    if error == nil {
        // Set successfull
    }
}

// B.  Save each individual user data (e.g. name, gender, description, etc) into different user state

let item = AgoraRtmStateItem()
item.key = "nameKey"
item.value = "Bac Huang"

let item2 = AgoraRtmStateItem()
item2.key = "titleKey"
item2.value = "TAM"

let item3 = AgoraRtmStateItem()
item3.key = "companyKey"
item3.value = "Agora"


// Publish/Set your user state 
if let (response, error) = await agoraRtmKit?.getPresence()?.setState(channelName: rootChannel, channelType: .message, items: [item, item2, item3]){
    if error == nil {
        // Set successfull
    }
}

```



**Setup RTM Presence Callback**
```swift
// Here is where you handle 
// Receive 'presence' event notifications in subscribed message channels and joined stream channels.
func rtmKit(_ rtmKit: AgoraRtmClientKit, didReceivePresenceEvent event: AgoraRtmPresenceEvent) {

    if event.type == .remoteLeaveChannel || event.type == .remoteConnectionTimeout {
    // A remote user left the channel e.g. event.publisher is offline
        
    }else if event.type == .remoteJoinChannel && event.publisher != nil {
     // A remote user subscribe the channel e.g. event.publisher is online
        
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



