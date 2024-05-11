//
//  ContactView.swift
//  Project1
//
//  Created by BBC on 2024/5/10.
//

import SwiftUI

struct ContactView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @Binding var contact: Contact
    @State var ownerID: String // To differentiate if user tap their own profile or others
    @State var isEditing: Bool = false
    
    var body: some View {
        VStack{
            // MARK: Top View
            VStack{
                Image(contact.avatar)
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                Text("\(contact.company)\(contact.company.isEmpty || contact.title.isEmpty ? "" : " | ")\(contact.title)")
                    .font(.title2)
                Text("\(contact.company), \(contact.title)")
                    .font(.subheadline)
                
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.2))
            
            // MARK: Contact Details
            VStack(alignment: .leading, spacing: 6){
                Text("Gender")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Picker("", selection: $contact.gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }
                .pickerStyle(.palette)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)

    
            // NAME
            VStack(alignment: .leading, spacing: 6){
                Text("Name")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $contact.name)
                    .modifier(CustomRectangleOutline())
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            
            // COMPANY
            VStack(alignment: .leading, spacing: 6){
                Text("Company")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $contact.company)
                    .modifier(CustomRectangleOutline())
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            
            // TITLE
            VStack(alignment: .leading, spacing: 6){
                Text("Title")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $contact.title)
                    .modifier(CustomRectangleOutline())
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            
            // DESCRIPTION
            VStack(alignment: .leading, spacing: 6){
                Text("Description")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $contact.description)
                    .modifier(CustomRectangleOutline())
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .disabled(!isEditing)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                // Edit button
                if contact.userID == ownerID {
                    Button(action : {
                        withAnimation {
                            if isEditing {
                                // Save it
                                Task {
                                    let _ = await agoraRTMVM.saveContact()
                                }
                            }
                            isEditing.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName:  isEditing ? "square.and.arrow.down" : "pencil")
                            Text(isEditing ? "Save" : "Edit")
                        }
                    }
                }
                
            }
        }
    }
}



#Preview {
    struct Preview: View {
        @State private var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default")
        
        var body: some View {
            ContactView(contact: $contact, ownerID: contact.userID)
                .environmentObject(AgoraRTMViewModel())
        }
    }
    
    return Preview()
}
