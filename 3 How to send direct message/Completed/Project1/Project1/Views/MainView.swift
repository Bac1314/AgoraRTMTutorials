//
//  MainView.swift
//  Project1
//
//  Created by BBC on 2024/5/15.
//

import SwiftUI

struct MainView: View {
    @StateObject var agoraRTMVM: AgoraRTMViewModel = AgoraRTMViewModel()
    
    var body: some View {
            if !agoraRTMVM.isLoggedIn {
                LoginView()
                    .environmentObject(agoraRTMVM)
            }else {
                TabView{
                    ChatsListView()
                        .environmentObject(agoraRTMVM)
                        .tabItem{
                            Label("Chats", systemImage: "message")
                        }
                    
                    ContactsListView()
                        .environmentObject(agoraRTMVM)
                        .tabItem{
                            Label("Friends", systemImage: "list.bullet")
                        }
                    
                    MeView()
                        .environmentObject(agoraRTMVM)
                        .tabItem{
                            Label("Me", systemImage: "person")
                        }
                
//                    if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == agoraRTMVM.userID}) {
//                        ContactDetailView(contact: $agoraRTMVM.listOfContacts[index], path: .constant(NavigationPath()))
//                            .environmentObject(agoraRTMVM)
//                            .tabItem{
//                                Label("Me", systemImage: "person")
//                            }
//                    }
                
                }
                .transition(.slide)
            }
    }
}

#Preview {
    MainView()
        .environmentObject(AgoraRTMViewModel())
}

