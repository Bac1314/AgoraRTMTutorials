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
    @State var ownerID: String // To differentiate if user tap their own profile or others
    @Binding var path: NavigationPath
    @State var temporaryContact: Contact = Contact(userID: "")
    @State var isEditing: Bool = false
    @State var showAlert: Bool = false
    
    var avatarImageNames : [String] = [
        "avatar_default", "avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7", "avatar8", "avatar9", "avatar10", "avatar11", "avatar12", "avatar_default2"
    ]
    
    var body: some View {
        ScrollView {
            
            // MARK: Top View
            VStack{
                Image(temporaryContact.avatar)
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                    .layoutPriority(2)
                    .padding(.top, 24)
                
                
                Text("@\(temporaryContact.userID)") // username
                    .foregroundStyle(Color.gray)
                    .padding(.bottom, 4)
                
                Text(temporaryContact.name.isEmpty ? "\(temporaryContact.userID)" : "\(temporaryContact.name)").bold()
                    .font(.title2)
                
                Text("\(temporaryContact.company)\(temporaryContact.company.isEmpty || temporaryContact.title.isEmpty ? "" : " | ")\(temporaryContact.title)")
                    .font(.subheadline)
                                
            }
            .frame(height: 360)
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
                                            .stroke(Color.accentColor, lineWidth: temporaryContact.avatar == imageName ? 2.0 : 0.0)
                                       )
                                      .onTapGesture {
                                          withAnimation {
                                              temporaryContact.avatar = imageName
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
                                    Image(systemName: gender == temporaryContact.gender ? "checkmark.circle.fill" : "circle")
                                    Text(gender.rawValue)
                                }
                                .modifier(CustomRectangleOutline(isEditing: $isEditing))
                                .onTapGesture {
                                    withAnimation {
                                        temporaryContact.gender = gender
                                    }
                                }
                            }
                        }
                    }
                }else if temporaryContact.gender != .prefernoresponse {
                    Text("Gender")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    HStack {
                        Text("\(temporaryContact.gender.rawValue)")
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
                
                TextField("", text: $temporaryContact.name)
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
                
                TextField("", text: $temporaryContact.company)
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
                
                TextField("", text: $temporaryContact.title)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
                
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .disabled(!isEditing)
            
            // DESCRIPTION
            VStack(alignment: .leading, spacing: 6){
                Text("Description")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextEditor(text: $temporaryContact.description)
                    .lineLimit(3)
                    .frame(minHeight: 80)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .padding(.bottom, 100)
            .disabled(!isEditing)
            

        }
        .onAppear(perform: {
            temporaryContact = contact
        })
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbar{
            // Back button
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
            
            ToolbarItem(placement: .topBarTrailing) {
                // Edit button
                if temporaryContact.userID == ownerID {
                    Button(action : {
                        withAnimation {
                            if isEditing {
                                // Save it
                                Task {
                                    print("Bac's reach here")
                                    contact = temporaryContact
                                    let _ = await agoraRTMVM.saveContact()
                                }
                            }
                            isEditing.toggle()
                        }
                    }){
                        HStack{
//                            Image(systemName:  isEditing ? "square.and.arrow.down" : "pencil")
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
                    let _ = await agoraRTMVM.saveContact()
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
        @State private var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default")
        
        var body: some View {
            ContactDetailView(contact: $contact, ownerID: contact.userID, path: .constant(NavigationPath()))
                .environmentObject(AgoraRTMViewModel())
        }
    }
    
    return Preview()
}
