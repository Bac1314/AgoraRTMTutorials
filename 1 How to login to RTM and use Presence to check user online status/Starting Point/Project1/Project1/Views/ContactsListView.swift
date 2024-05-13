//
//  ContactsListView.swift
//  Project1
//
//  Created by BBC on 2024/5/9.
//

import SwiftUI

struct ContactsListView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack(alignment: .leading){
            // MARK: Show your contact
            VStack(alignment: .leading) {
                Text("Me")
                // Display contact
                // ContactListItemView()
            }
            .padding()
            
            // MARK: Show friends contact
            VStack(alignment: .leading) {
                Text("Online Friends")
                // Display list of contacts
                // List of ContactListItemView()
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
                    // Logout action
                    // ..
                    
                    // Remove path aka go back
                    path.removeLast()
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
}
