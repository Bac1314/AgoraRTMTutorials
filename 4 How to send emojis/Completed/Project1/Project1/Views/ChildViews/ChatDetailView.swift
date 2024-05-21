//
//  ChatDetailView.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import SwiftUI


struct ChatDetailView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @Binding var friendContact: Contact
    @Binding var path: NavigationPath
    @FocusState private var keyboardIsFocused: Bool
    @State var typeNewMessage: String = ""
    @State var lastMessageID: UUID = UUID() // for scrolling
    @State var isEmoji: Bool = false

    
    var body: some View {
        // List of messages
        VStack {
            // MARK: DISPLAY LIST OF MESSAGES
            ScrollViewReader {proxy in
                ScrollView{
                    ForEach(agoraRTMVM.messages.filter { message in
                        return filteredMessage(message: message)
                    }) { message in
                        
                        if let senderContact = agoraRTMVM.listOfContacts.first(where: {$0.userID == message.sender}) {
                            MessageItemLocalView(contact: senderContact, customMessage: message, isSender: message.sender == agoraRTMVM.userID)
                        }else {
                            Text("Contact not found")
                        }

                    }
                }
                .onChange(of: agoraRTMVM.messages.last?.id) { oldValue, newValue in
                    if let value = agoraRTMVM.messages.filter({ message in
                        return filteredMessage(message: message)}).last?.id  {
                        withAnimation {
                            proxy.scrollTo(value, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    if let value = agoraRTMVM.messages.filter({ message in
                        return filteredMessage(message: message)}).last?.id  {
                        proxy.scrollTo(value, anchor: .bottom)
                    }
  
                }
            }
            
            
            // MARK: SEND MESSAGE VIEW
            HStack{
                
                TextField("Enter Message", text: $typeNewMessage)
                    .textFieldStyle(.roundedBorder)
                    .focused($keyboardIsFocused)
                    .onSubmit {
                        Task{
                            keyboardIsFocused = false // dismiss keyboard
                            
                            let result = await agoraRTMVM.publishToUser(userName: friendContact.userID, messageString: typeNewMessage, customType: nil)
                            
                            if result {
                                typeNewMessage = "" // Reset
                            }
                        }
                    }
                

                Image(systemName: "smiley")
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation {
                            isEmoji.toggle()
                            keyboardIsFocused = false
                            
                        }
                    }
                
                Button(action: {
                    Task{
                        keyboardIsFocused = false // dismiss keyboard
                        
                        let result = await agoraRTMVM.publishToUser(userName: friendContact.userID, messageString: typeNewMessage, customType: nil)
                        
                        if result {
                            typeNewMessage = "" // Reset
                        }
                    }
                }, label: {
                    Text("Send")
                })
                .buttonStyle(.bordered)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .navigationTitle(friendContact.name.isEmpty ? friendContact.userID : friendContact.name)
    }
    
    func filteredMessage(message: CustomMessage) -> Bool {
        return (message.sender == agoraRTMVM.userID && message.receiver == friendContact.userID) ||
        (message.sender == friendContact.userID && message.receiver == agoraRTMVM.userID)
    }
    
}


#Preview {
    struct Preview: View {
        @State private var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default", online: true)
        
        var body: some View {
            ChatDetailView(friendContact: $contact, path: .constant(NavigationPath()))
                .environmentObject(AgoraRTMViewModel())
        }
    }
    
    return Preview()
}
