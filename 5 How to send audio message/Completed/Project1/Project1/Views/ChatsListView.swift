//
//  ChatsListView.swift
//  Project1
//
//  Created by BBC on 2024/5/15.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @State var path = NavigationPath()
    @State var searchText = ""
    
    // TESTING
    @State var userName = ""
    @State var count = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                if agoraRTMVM.listOfContacts.count == 0  {
                    VStack(alignment: .center, spacing: 15) {
                        Image(systemName: "tray")
                            .font(.largeTitle)

                        Text("Oh, so empty!")
                            .font(.headline)
                    }
                    .foregroundStyle(Color.secondary)
                }else {
                    // ChatListItemView
                    List {
                        ForEach(agoraRTMVM.listOfContacts.filter({ contact in
                            return (searchText.isEmpty ||
                            (contact.contains(searchText: searchText))) &&
                            agoraRTMVM.friendList.contains(where: { $0.userID == contact.userID})
                        }), id: \.userID) { friendContact in
                            
                            let lastMessage = agoraRTMVM.messages.filter({($0.sender == agoraRTMVM.userID && $0.receiver == friendContact.userID ) || ($0.sender == friendContact.userID && $0.receiver == agoraRTMVM.userID) }).last

                            ChatListItemView(contact: friendContact, lastMessage: lastMessage?.message ?? "", lastMessageType: lastMessage?.messageType ?? .text)
                                .onTapGesture {
                                    path.append(customNavigateType.ChatDetailView(username: friendContact.userID))
                                }
                            
                        }
                        
                    }
                    .listStyle(.plain)
                    .padding()

                    Spacer()
                }

            }
            .toolbar(.visible, for: .tabBar)
            .searchable(text: $searchText)
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: customNavigateType.self) { value in
                switch value {
                case .ContactDetailView(let userName):
                    if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == userName}){
                        // Go to ContactDetailView
                        ContactDetailView(contact: $agoraRTMVM.listOfContacts[index], path: $path)
                            .environmentObject(agoraRTMVM)
                    }else {
                        Text("user not found")
                    }
                    
                case .ChatDetailView(let userName):
                    if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == userName}){
                        // Go to ContactDetailView
                        ChatDetailView(friendContact: $agoraRTMVM.listOfContacts[index], path: $path)
                            .environmentObject(agoraRTMVM)
                    }else {
                        Text("user not found")
                    }
                }
            }
        }
    }
}

#Preview {
    ChatsListView()
        .environmentObject(AgoraRTMViewModel())
}
