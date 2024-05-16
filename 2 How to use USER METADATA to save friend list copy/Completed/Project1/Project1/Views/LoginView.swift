//
//  LoginView.swift
//  Project1
//
//  Created by BBC on 2024/5/9.
//

import SwiftUI

struct LoginView: View {
    @StateObject var agoraRTMVM: AgoraRTMViewModel = AgoraRTMViewModel()
    @State var isLoading : Bool = false
    @State var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path){
            VStack(alignment: .center, spacing: 6){
                Image("avatar_default")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                    .padding(.bottom, 40)
                
        
                HStack{
                    TextField("Input User ID", text: $agoraRTMVM.userID)
                        .padding(.horizontal)
                        .textFieldStyle(.plain)
                        .font(.headline)
                    
                    Button(action: {
                        // Login Action
                        Task {
                            do{
                                isLoading = true
                                try await agoraRTMVM.loginRTM()
                                isLoading = false
                                
                                path.append("ContactsListView") // Navigate to main view
                            }catch {
                                isLoading = false
                                print("Login error \(error.localizedDescription)")
                            }
                        }
                    }, label: {
                        Text("Login")
                            .bold()
                            .frame(width: 80, height: 49)
                            .foregroundStyle(Color.white)
                            .background(
                                Color.black
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    })
                    .buttonStyle(.plain)
                }
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray, lineWidth: 1.0)
                )
            }
            .padding()
            .navigationDestination(for: String.self, destination: { value in
                if value == "ContactsListView"{
                    ContactsListView(path: $path)
                        .environmentObject(agoraRTMVM)
                }else if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == value}){
                    // Go to ContactDetailView
                    ContactDetailView(contact: $agoraRTMVM.listOfContacts[index], ownerID: agoraRTMVM.userID, path: $path)
                        .environmentObject(agoraRTMVM)
                }
        
            })
            .overlay {
                // MARK: Loading Icon
                if isLoading {
                    ProgressView()
                        .scaleEffect(CGSize(width: 3.0, height: 3.0))
                }
            }
            
        }

    }
}

#Preview {
    LoginView()
}
