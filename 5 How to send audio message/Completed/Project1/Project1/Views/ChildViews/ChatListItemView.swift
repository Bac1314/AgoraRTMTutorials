//
//  ChatListItemView.swift
//  Project1
//
//  Created by BBC on 2024/5/20.
//

import SwiftUI

struct ChatListItemView: View {
    var contact: Contact
    var lastMessage: String
    var lastMessageType: customMessageType
    
    var body: some View {
        
        HStack {
            Image(contact.avatar)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundStyle(contact.online ? Color.green : Color.gray)
                        .offset(x: 5, y: -5)
                }
            
            VStack(alignment: .leading) {
                Text(contact.name.isEmpty ? "\(contact.userID)" : "\(contact.name)").bold()
                
                if lastMessageType == .text {
                    Text(lastMessage)
                        .lineLimit(1)
                }else if lastMessageType == .audio {
                    HStack {
                        Image(systemName: "dot.radiowaves.right")
                        Text("Audio File").lineLimit(1)
                        Spacer()
                    }
                }
                else if lastMessageType == .file {
                    HStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                        Text("File").lineLimit(1)
                        Spacer()
                    }
                }

            }
            
            Spacer()
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}

#Preview {
    struct Preview: View {
        var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default")
        
        var body: some View {
            ChatListItemView(contact: contact, lastMessage: "Hello World", lastMessageType: .text)
        }
    }
    
    return Preview()
}
