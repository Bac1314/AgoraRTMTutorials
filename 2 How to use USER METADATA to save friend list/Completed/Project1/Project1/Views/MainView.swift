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

                
                }
                .transition(.slide)
            }
    }
}

#Preview {
    MainView()
        .environmentObject(AgoraRTMViewModel())
}

