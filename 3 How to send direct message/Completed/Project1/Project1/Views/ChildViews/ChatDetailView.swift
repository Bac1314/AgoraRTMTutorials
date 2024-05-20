//
//  ChatDetailView.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import SwiftUI

struct ChatDetailView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @Binding var contact: Contact
    @Binding var path: NavigationPath
    @FocusState private var keyboardIsFocused: Bool
    @State var typeNewMessage: String = ""
    @State var lastMessageID: UUID = UUID() // for scrolling

    
    var body: some View {
        // List of messages
        VStack {
            // MARK: DISPLAY LIST OF MESSAGES
            ScrollViewReader {proxy in
                ScrollView{
                    ForEach(agoraRTMVM.messages.filter { message in
                        return (message.sender == agoraRTMVM.userID && message.receiver == contact.userID) ||
                        (message.sender == contact.userID && message.receiver == agoraRTMVM.userID)
                    }) { message in
                        MessageItemLocalView(from: message.sender, message: message.message, isSender: (message.sender == agoraRTMVM.userID && message.receiver == contact.userID) )
                    }
                }
                .onChange(of: agoraRTMVM.messages.last?.id) { oldValue, newValue in
                    if let value = newValue {
                        withAnimation {
                            proxy.scrollTo(value, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    if let value = agoraRTMVM.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(value, anchor: .bottom)
                        }
                    }
  
                }
            }
            
            
            // MARK: SEND MESSAGE VIEW
            HStack{
                TextField("Enter Message", text: $typeNewMessage)
                    .textFieldStyle(.roundedBorder)
                    .focused($keyboardIsFocused)
                
                Button(action: {
                    Task{
                        keyboardIsFocused = false // dismiss keyboard
                        
                        let result = await agoraRTMVM.publishToUser(userName: contact.userID, messageString: typeNewMessage, customType: nil)
                        
                        if result {
                            typeNewMessage = "" // Reset
                        }
                    }
                }, label: {
                    Text("Publish")
                })
                .buttonStyle(.bordered)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .padding(.horizontal)
        .navigationTitle(contact.userID)
    }
}


#Preview {
    struct Preview: View {
        @State private var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default", online: true)
        
        var body: some View {
            ChatDetailView(contact: $contact, path: .constant(NavigationPath()))
                .environmentObject(AgoraRTMViewModel())
        }
    }
    
    return Preview()
}
