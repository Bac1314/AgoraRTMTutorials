//
//  MessagingView.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import SwiftUI

struct MessagingView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @Binding var contact: Contact
    @Binding var path: NavigationPath
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    struct Preview: View {
        @State private var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default", online: true)
        
        var body: some View {
            MessagingView(contact: $contact, path: .constant(NavigationPath()))
                .environmentObject(AgoraRTMViewModel())
        }
    }
    
    return Preview()
}
