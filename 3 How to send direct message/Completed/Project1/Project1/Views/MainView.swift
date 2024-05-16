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
                    
                }
                .transition(.slide)
            }
    }
}

#Preview {
    MainView()
        .environmentObject(AgoraRTMViewModel())
}

