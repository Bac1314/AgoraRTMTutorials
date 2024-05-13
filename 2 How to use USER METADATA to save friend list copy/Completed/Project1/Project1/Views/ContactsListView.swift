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
    @State var searchText = ""

    var body: some View {
        VStack(alignment: .leading){
            // MARK: Show your contact
            VStack(alignment: .leading) {
                Text("Me")

                if let contactMe = agoraRTMVM.listOfContacts.first(where: {$0.userID == agoraRTMVM.userID}) {
                    if (searchText.isEmpty ||  contactMe.userID.lowercased().contains(searchText.lowercased()) || contactMe.name.lowercased().contains(searchText.lowercased()) || contactMe.company.lowercased().contains(searchText.lowercased())) {
                        ContactsListItemView(contact: contactMe)
                            .onTapGesture {
                                path.append(contactMe.userID)
                            }
                    }
                }
            }
            .padding()
            
            // MARK: Show friends contact
            VStack(alignment: .leading) {
                Text("Online Friends")
                ForEach(agoraRTMVM.listOfContacts, id: \.userID) { contact in
                    if contact.userID != agoraRTMVM.userID && 
                        (searchText.isEmpty ||  contact.userID.lowercased().contains(searchText.lowercased()) || contact.name.lowercased().contains(searchText.lowercased()) || contact.company.lowercased().contains(searchText.lowercased())){
                        ContactsListItemView(contact: contact)
                            .onTapGesture {
                                path.append(contact.userID)
                            }
                    }
 
                }
            }
            .padding()

            
            Spacer()
            
            // Show number friends
            HStack(alignment: .center){
                
                Spacer()
                Text("\(agoraRTMVM.listOfContacts.count-1) friends")
                    .foregroundStyle(Color.gray)
                Spacer()
            }
        }
        .searchable(text: $searchText)
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
                        Text("Logout")
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
