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
                // ChatListItemView
                List {
                    ForEach(agoraRTMVM.listOfContacts.filter({ contact in
                        return (searchText.isEmpty ||
                        (contact.contains(searchText: searchText))) &&
                        agoraRTMVM.friendList.contains(where: { $0.userID == contact.userID})
                    }), id: \.userID) { friendContact in
                        ChatListItemView(contact: friendContact, lastMessage: "\(agoraRTMVM.messages.last(where: {$0.sender == friendContact.userID})?.message ?? "")")
                            .onTapGesture {
                                path.append(customNavigateType.ChatDetailView(username: friendContact.userID))
                            }
                    }
                    
                    
                }
                .listStyle(.plain)
                .padding()

                
                Spacer()
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
                        ChatDetailView(contact: $agoraRTMVM.listOfContacts[index], path: $path)
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
