//
//  ContactsListView.swift
//  Project1
//
//  Created by BBC on 2024/5/9.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @Binding var path: NavigationPath

    var body: some View {
        VStack(alignment: .leading){
            // MARK: Show your contact
            VStack(alignment: .leading) {
                Text("Me")
                if let currentUserIndex = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == agoraRTMVM.userID}) {
                    ContactsListItemView(contact: agoraRTMVM.listOfContacts[currentUserIndex])
                        .onTapGesture {
                            path.append(agoraRTMVM.listOfContacts[currentUserIndex].userID)
                        }
                }
            }
            .padding()
            
            // MARK: Show friends contact
            VStack(alignment: .leading) {
                Text("Online Friends")
                ForEach(agoraRTMVM.listOfContacts, id: \.userID) { contact in
                    if contact.userID != agoraRTMVM.userID {
                        ContactsListItemView(contact: contact)
                            .onTapGesture {
                                path.append(contact.userID)
                            }
                    }
 
                }
            }
            .padding()

            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Contacts")
        .toolbar{
            // Back button
            ToolbarItem(placement: .topBarLeading) {
                Button(action : {
                    agoraRTMVM.logoutRTM()
                    path.removeLast()
//                    self.mode.wrappedValue.dismiss()
                }){
                    HStack{
                        Image(systemName: "arrow.left")
                        Text(agoraRTMVM.isLoggedIn ? "Logout" : "Back")
                    }
                }
            }
        }
    }
}

#Preview {
    ContactsListView(path: .constant(NavigationPath()))
        .environmentObject(AgoraRTMViewModel())
}
