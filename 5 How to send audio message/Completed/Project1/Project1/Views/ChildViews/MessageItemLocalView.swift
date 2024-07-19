//
//  MessageItemLocalView.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import SwiftUI

struct MessageItemLocalView: View {
    var contact: Contact
    var customMessage: CustomMessage
    var isSender: Bool

    var onButtonTap: (() -> Void)?

    var body: some View {
        if isSender {
            HStack(alignment: .bottom){
                Image(contact.avatar)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4){
//                    Text("Me - \(contact.name.isEmpty ? contact.userID : contact.name)")
//                        .foregroundStyle(Color.accentColor)
                    
                    Text(customMessage.lastUpdated, format: .dateTime)
                        .font(.caption)

                    // Display Text
                    Text(customMessage.message ?? "")
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                }
                Spacer()
                
            }
            .padding(.bottom, 10)
        }else {
            HStack(alignment: .bottom){

                Spacer()
                VStack(alignment: .trailing, spacing: 4){
//                    Text("\(contact.name.isEmpty ? contact.userID : contact.name)")
//                        .foregroundStyle(Color.accentColor)
//                    
                    Text(customMessage.lastUpdated, format: .dateTime)
                        .font(.caption)

                    
                    // Display Text
                    Text(customMessage.message ?? "")
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                }
                
                Image(contact.avatar)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        self.onButtonTap?()
                    }
            }
            .padding(.bottom, 10)
        }

    }
}


#Preview {
    struct Preview: View {
        var message = CustomMessage(id: UUID(), message: "Testing message", sender: "Bac", receiver: "Stan", lastUpdated: Date())
        var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default")
        
        var body: some View {
            MessageItemLocalView(contact: contact, customMessage: message, isSender: true)
        }
    }
    
    return Preview()
}
