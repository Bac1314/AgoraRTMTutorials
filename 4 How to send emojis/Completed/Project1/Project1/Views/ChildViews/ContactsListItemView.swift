//
//  ContactsListItemView.swift
//  Project1
//
//  Created by BBC on 2024/5/10.
//

import SwiftUI

struct ContactsListItemView: View {
    var contact: Contact
    var isFriend: Bool
    
    var body: some View {
        HStack(spacing: 12){
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
            
            VStack(alignment: .leading){
                Text(contact.name.isEmpty ? "\(contact.userID)" : "\(contact.name)").bold()
                Text("\(contact.company)\(contact.company.isEmpty || contact.title.isEmpty ? "" : " | ")\(contact.title)")
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            if isFriend {
                Image(systemName: "person.2")
            }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}

#Preview {
    struct Preview: View {
        var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default")
        
        var body: some View {
            ContactsListItemView(contact: contact, isFriend: false)
        }
    }
    
    return Preview()
}
