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
    @FocusState var keyboardIsFocused: Bool
    @State var typeNewMessage: String = ""
    @State var lastMessageID: UUID = UUID() // for scrolling

    var bottomID = UUID()
    
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
                            MessageItemLocalView(contact: senderContact, customMessage: message, isSender: message.sender == agoraRTMVM.userID) {
                                
                                // Navigate to contact detail view
                                path.append(customNavigateType.ContactDetailView(username: senderContact.userID))
                            }
                        }else {
                            Text("Contact not found")
                        }

                    }
                    
                    // For scrolling
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        .id(bottomID)
                }
                .scrollDismissesKeyboard(.immediately)
                .onAppear {
                    proxy.scrollTo(bottomID)
                }
                .onChange(of: agoraRTMVM.messages.count) { oldValue, newValue in
                    withAnimation {
                        proxy.scrollTo(bottomID)
                    }

                }
                .onChange(of: keyboardIsFocused) { old, new in
                    Task {
                        try? await Task.sleep(nanoseconds: 3 * 100_000_000)
                        withAnimation {
                            proxy.scrollTo(bottomID)
                        }
                    }

                }
        
            }
            
            
            // MARK: SEND MESSAGE VIEW
            HStack{
                
                HStack{
                    TextField("Enter Message", text: $typeNewMessage)
                        .textFieldStyle(.plain)
                        .focused($keyboardIsFocused)
                        .onSubmit {
                            Task{
                                let result = await agoraRTMVM.publishToUser(userName: friendContact.userID, messageString: typeNewMessage, customType: nil)
                                
                                if result {
                                    typeNewMessage = "" // Reset
                                }
                            }
                        }
                        .disabled(!friendContact.online)
                    
                    Button(action: {
                        Task{
                            let result = await agoraRTMVM.publishToUser(userName: friendContact.userID, messageString: typeNewMessage, customType: nil)
                            
                            if result {
                                typeNewMessage = "" // Reset
                            }
                        }
                    }, label: {
                        Image(systemName: "paperplane")
                            .imageScale(.large)
                    })
                    .disabled(typeNewMessage.isEmpty || !friendContact.online)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.gray, lineWidth: 1.0)
                )



            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
               ToolbarItem(placement: .principal) {
                   HStack(alignment: .center){
                       Text("\(friendContact.name.isEmpty ? friendContact.userID : friendContact.name)")
                           .font(.headline)
                           .onTapGesture {
                               // Navigate to contact detail view
                               path.append(customNavigateType.ContactDetailView(username: friendContact.userID))
                           }
                       
                      Image(systemName: "circle.fill")
                          .imageScale(.small)
                          .foregroundStyle(friendContact.online ? Color.green : Color.gray)
                   }
            
               }
        }
        .toolbarTitleDisplayMode(.large)
//        .navigationTitle(friendContact.name.isEmpty ? friendContact.userID : friendContact.name)
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
