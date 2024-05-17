//
//  MeView.swift
//  Project1
//
//  Created by BBC on 2024/5/17.
//

import SwiftUI

struct MeView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    
    var body: some View {
        NavigationStack() {
            ZStack {
                if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == agoraRTMVM.userID}) {
                    ContactDetailView(contact: $agoraRTMVM.listOfContacts[index], path: .constant(NavigationPath()))
                        .environmentObject(agoraRTMVM)
                        .tabItem{
                            Label("Me", systemImage: "person")
                        }
                }
                else {
                    Text("Profile not found")
                }
                
            }
            .toolbar(.visible, for: .tabBar)
            .navigationTitle("Me")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ChatsListView()
        .environmentObject(AgoraRTMViewModel())
}
