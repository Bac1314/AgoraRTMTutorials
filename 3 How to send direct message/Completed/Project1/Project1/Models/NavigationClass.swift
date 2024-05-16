//
//  NavigationClass.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import Foundation
import SwiftUI


//class NavigationClass {
//    func navigate(to page: customNavigateType, path: NavigationPath, agoraRTMVM: AgoraRTMViewModel) -> AnyView{
//            switch page {
//        
//            case .MainView:
//                return AnyView(Text("Hello World"))
//            case .LoginView:
//                return AnyView(Text("Hello World"))
//            case .ChatsListView:
//                return AnyView(Text("Hello World"))
//            case .ContactsListView:
//                return AnyView(Text("Hello World"))
//            case .ContactDetailView(let userName):
//                if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == userName}){
//                    // Go to ContactDetailView
//                    return AnyView(ContactDetailView(contact: $agoraRTMVM.listOfContacts[index], path: $path)
//                        .environmentObject(agoraRTMVM))
//                }else {
//                    AnyView(Text("user not found"))
//                }
//            case .MessagingView(let userName):
//                if let index = agoraRTMVM.listOfContacts.firstIndex(where: {$0.userID == userName}){
//                    // Go to ContactDetailView
//                    MessagingView()
//                        .environmentObject(agoraRTMVM)
//                }else {
//                    return AnyView(Text("User Not Found"))
//                }
//        
//            }
//    }
//}
//
//
