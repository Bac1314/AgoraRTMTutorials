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
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .toolbar(.visible, for: .tabBar)
            .navigationTitle("Chats")
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
    ChatsListView()
        .environmentObject(AgoraRTMViewModel())
}
