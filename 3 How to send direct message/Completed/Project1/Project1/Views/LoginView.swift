//
//  LoginView.swift
//  Project1
//
//  Created by BBC on 2024/5/9.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @State var isLoading : Bool = false
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 6){
                Image(agoraRTMVM.userAvatar)
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
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray, lineWidth: 1.0)
                )
            }

        }
        .padding()
        .overlay {
            // MARK: Loading Icon
            if isLoading {
                ProgressView()
                    .scaleEffect(CGSize(width: 3.0, height: 3.0))
            }
        }
        
    }
}

#Preview {
    LoginView()
        .environmentObject(AgoraRTMViewModel())
}
