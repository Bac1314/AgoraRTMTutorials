//
//  ContactDetailView.swift
//  Project1
//
//  Created by BBC on 2024/5/10.
//

import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @Binding var contact: Contact
    @Binding var path: NavigationPath
    @State var temporaryContact: Contact = Contact(userID: "")
    @State var isEditing: Bool = false
    @State var showAlert: Bool = false
    
    var avatarImageNames : [String] = [
        "avatar_default", "avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7", "avatar8", "avatar9", "avatar10", "avatar11", "avatar12", "avatar_default2"
    ]
    
    @State var toggleing: Bool = false
    
    var body: some View {
        ScrollView {
            // MARK: Top View
            VStack{
                Image(contact.avatar)
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: "circle.fill")
                            .imageScale(.medium)
                            .foregroundStyle(contact.online ? Color.green : Color.gray)
                            .offset(x: 8, y: -8)
                            .symbolEffect(.bounce, options: .speed(3).repeat(3), value: contact.online)

                    }
                    .padding()
                    .layoutPriority(2)
                    .padding(.top, 24)
    
                
                
                Text("@\(contact.userID)") // username
                    .foregroundStyle(Color.gray)
                    .padding(.bottom, 4)
                
                Text(contact.name.isEmpty ? "\(contact.userID)" : "\(contact.name)").bold()
                    .font(.title2)
                
                Text("\(contact.company)\(contact.company.isEmpty || contact.title.isEmpty ? "" : " | ")\(contact.title)")
                    .font(.subheadline)
          
                                
            }
            .frame(height: 420)
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.2).gradient)
            
            
            // MARK: Contact Details
            // AVATAR SELECTION
            if isEditing {
                VStack(alignment: .leading, spacing: 6){
                    Text("Avatars")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 16){
                            ForEach(avatarImageNames, id: \.self) { imageName in
                                  Image(imageName)
                                      .resizable()
                                      .aspectRatio(contentMode: .fit)
                                      .frame(width: 50, height: 50)
                                      .clipShape(RoundedRectangle(cornerRadius: 12))
                                      .padding(4)
                                      .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(Color.accentColor, lineWidth: contact.avatar == imageName ? 2.0 : 0.0)
                                       )
                                      .onTapGesture {
                                          withAnimation {
                                              contact.avatar = imageName
                                          }
                                      }
                            }
                        }

                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .disabled(!isEditing)
            }
            
            // GENDER SELECTION
            VStack(alignment: .leading, spacing: 6){
                if isEditing {
                    Text("Gender")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 16){
                            ForEach(Gender.allCases, id: \.self) { gender in
                                HStack{
                                    Image(systemName: gender == contact.gender ? "checkmark.circle.fill" : "circle")
                                    Text(gender.rawValue)
                                }
                                .modifier(CustomRectangleOutline(isEditing: $isEditing))
                                .onTapGesture {
                                    withAnimation {
                                        contact.gender = gender
                                    }
                                }
                            }
                        }
                    }
                }else if contact.gender != .prefernoresponse {
                    Text("Gender")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    HStack {
                        Text("\(contact.gender.rawValue)")
                            .font(.headline)
                        Spacer()
                    }
                    
                }

            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .disabled(!isEditing)
    
            // NAME
            VStack(alignment: .leading, spacing: 6){
                Text("Name")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $contact.name)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .disabled(!isEditing)
            
            // COMPANY
            VStack(alignment: .leading, spacing: 6){
                Text("Company")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $contact.company)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .disabled(!isEditing)
            
            // TITLE
            VStack(alignment: .leading, spacing: 6){
                Text("Title")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $contact.title)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
                
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .disabled(!isEditing)
            
            // DESCRIPTION
            if isEditing || (!isEditing && !contact.description.isEmpty) {
                VStack(alignment: .leading, spacing: 6){
                    Text("Description")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    TextEditor(text: $contact.description)
                        .lineLimit(3)
                        .frame(minHeight: 80)
                        .modifier(CustomRectangleOutline(isEditing: $isEditing))
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .disabled(!isEditing)
            }

            
            // Button to add as friend or remove friend
            if contact.userID != agoraRTMVM.userID {
                Button(action: {
                    if agoraRTMVM.friendList.contains(where: { $0.userID == contact.userID}) {
                        agoraRTMVM.removeFriend(contact: contact)
                    }else {
                        agoraRTMVM.addAsFriend(contact: contact)
                    }
                }, label: {
                    Text( agoraRTMVM.friendList.contains(where: { $0.userID == contact.userID}) ? "Remove friend" : "Add friend")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(agoraRTMVM.friendList.contains(where: { $0.userID == contact.userID}) ? Color.red : Color.accentColor)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                        .padding(.vertical)
                })
            }
            

        }
        .toolbar(contact.userID != agoraRTMVM.userID ? .hidden : .visible, for: .tabBar)
        .onAppear(perform: {
            temporaryContact = contact
        })
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbar{
            // Back button
            
            if contact.userID != agoraRTMVM.userID {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action : {
                        if contact.isEqual(to: temporaryContact) {
                            path.removeLast()
                        }else {
                            withAnimation {
                                showAlert.toggle()
                            }
                        }
                    }){
                        HStack{
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                    }
                }
            }
            
            else if contact.userID == agoraRTMVM.userID {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action : {
                        withAnimation {
                            agoraRTMVM.logoutRTM()
                        }
                    }){
                        HStack{
                            Text("Logout")
                                .foregroundStyle(Color.red)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    // Edit button
                        Button(action : {
                            withAnimation {
                                if isEditing {
                                    // Save it
                                    Task {
                                        temporaryContact = contact
                                        let _ = await agoraRTMVM.setUserPresenceProfile()
                                    }
                                }
                                isEditing.toggle()
                            }
                        }){
                            HStack{
                                Text(isEditing ? "Save" : "Edit")
                                    .bold()
                                    .disabled(isEditing && contact.isEqual(to: temporaryContact))
                            }
                            .padding(12)
                        }
                    
                }
            }

        }
        .alert("Unsave changes", isPresented: $showAlert) {
            
            Button("Save", role: .none) {
                Task {
                    contact = temporaryContact
                    let _ = await agoraRTMVM.setUserPresenceProfile()
                    path.removeLast()
                }
            }
            
            Button("Discard", role: .destructive) {
                path.removeLast()
            }
 
        }
    }
}



#Preview {
    struct Preview: View {
        @State private var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default", online: true)
        
        var body: some View {
            ContactDetailView(contact: $contact, path: .constant(NavigationPath()))
                .environmentObject(AgoraRTMViewModel())
        }
    }
    
    return Preview()
}
