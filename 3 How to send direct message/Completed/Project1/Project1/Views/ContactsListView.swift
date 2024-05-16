//
//  ContactsListView.swift
//  Project1
//
//  Created by BBC on 2024/5/9.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @State var path = NavigationPath()
    @State var searchText = ""
    @State var showFriendsOnly : Bool = true
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading){
                // MARK: Show your contact
                VStack(alignment: .leading) {
                    Text("Me")
                        .font(.headline)
                    
                    if let contactMe = agoraRTMVM.listOfContacts.first(where: {$0.userID == agoraRTMVM.userID}) {
                        if (searchText.isEmpty ||  contactMe.contains(searchText: searchText)) {
                            ContactsListItemView(contact: contactMe, isFriend: agoraRTMVM.friendList.contains(contactMe.userID))
                                .onTapGesture {
                                    path.append(customNavigateType.ContactDetailView(username: contactMe.userID))
                                }
                        }
                    }
                }
                .padding()
                
                // MARK: Show friends contact
                VStack(alignment: .leading) {
                    HStack{
                        Text("Users")
                            .font(.headline)
                        Spacer()
                        Picker(selection: $showFriendsOnly, label: Text("")) {
                            Text("Friends Only").tag(true)
                            Text("All Online Users").tag(false)
                        }
                    }
                    
                    List {
                        ForEach(agoraRTMVM.listOfContacts.filter { contact in
                            return contact.userID != agoraRTMVM.userID
                            && (searchText.isEmpty || contact.contains(searchText: searchText))
                            && (showFriendsOnly == true ? agoraRTMVM.friendList.contains(contact.userID) : false
                                || showFriendsOnly == false ? contact.online : false)
                        }, id: \.userID) { contact in
                            ContactsListItemView(contact: contact, isFriend: agoraRTMVM.friendList.contains(contact.userID))
                                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                .swipeActions(edge: .trailing) {
                                    if agoraRTMVM.friendList.contains(contact.userID) {
                                        Button(role: .destructive) {
                                            Task {agoraRTMVM.removeFriend(contact:contact) }} label: { Text("Remove friend") }
                                    }else {
                                        Button {
                                            Task {agoraRTMVM.addAsFriend(contact:contact) }} label: {Text("Add friend")  }.tint(.green)
                                    }
                                    
                                }
                                .onTapGesture {
                                    path.append(customNavigateType.ContactDetailView(username: contact.userID))
                                }
                        }
                    }
                    .listStyle(.plain)
                    
                }
                .padding()
                
                Spacer()
                
                // Footer: Show number friends
                HStack(alignment: .center){
                    Spacer()
                    if showFriendsOnly {
                        Text("\(agoraRTMVM.friendList.count) friends, \(agoraRTMVM.listOfContacts.filter({$0.online && agoraRTMVM.friendList.contains($0.userID)}).count) online")
                            .foregroundStyle(Color.gray)
                    }else {
                        Text("\(agoraRTMVM.listOfContacts.filter({$0.online}).count) online")
                            .foregroundStyle(Color.gray)
                    }
                    Spacer()
                }
            }
            .searchable(text: $searchText)
            .toolbar(.visible, for: .tabBar)
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: customNavigateType.self) { value in
                switch value {
            
                case .MainView:
                    Text("Hello World")
                case .LoginView:
                    Text("Hello World")
                case .ChatsListView:
                    Text("Hello World")
                case .ContactsListView:
                    Text("Hello World")
                case .ContactDetailView(let userName):
                    if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == userName}){
                        // Go to ContactDetailView
                        ContactDetailView(contact: $agoraRTMVM.listOfContacts[index], path: $path)
                            .environmentObject(agoraRTMVM)
                    }else {
                        Text("user not found")
                    }
            
                case .MessagingView(let userName):
                    if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == userName}){
                        // Go to ContactDetailView
                        MessagingView()
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
    ContactsListView()
        .environmentObject(AgoraRTMViewModel())
}