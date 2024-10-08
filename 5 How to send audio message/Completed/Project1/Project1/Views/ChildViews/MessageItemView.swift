//
//  MessageItemLocalView.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import SwiftUI
import MobileCoreServices

struct MessageItemView: View {
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
                    Text(customMessage.lastUpdated, format: .dateTime)
                        .font(.caption)
                        .onTapGesture {
                            print(customMessage.messageLocalURL ?? "Emtpy")
                        }
                    
             
                    // Display image it exist
                    if let localURL = customMessage.messageLocalURL, let imageData = try? Data(contentsOf: localURL), let image = UIImage(data: imageData) {
                        Image(localURL.path())
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 70)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                    }
                    
                    
                    // Display Message Data
                    if customMessage.messageType == .text {
                        Text(customMessage.message ?? "")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    } else if customMessage.messageType == .audio {
                        HStack {
                            Image(systemName: "dot.radiowaves.right")
                            Text("\(customMessage.getAudioFileDuration())s")
                            Spacer()
                        }
                        .frame(width: max(60 ,min(CGFloat(customMessage.getAudioFileDuration()) * 20, 200)))
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                    } else if  customMessage.messageType == .file  {
                        HStack {
                            Image(systemName: "filemenu.and.cursorarrow")
                            Text(customMessage.fileName ?? "No file name")
                            Spacer()
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                    } else if customMessage.messageType == .image {
                        HStack {
                            Image(systemName: "photo")
                            Text(customMessage.fileName ?? "No file name")
                            Spacer()
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                    }
                    
                    
                }
                Spacer()
                
            }
            .padding(.bottom, 10)
        }else {
            HStack(alignment: .bottom){
                Spacer()
                VStack(alignment: .trailing, spacing: 4){
                    Text(customMessage.lastUpdated, format: .dateTime)
                        .font(.caption)
                    
                    // Display image it exist
                    if let localURL = customMessage.messageLocalURL, let imageData = try? Data(contentsOf: localURL), let image = UIImage(data: imageData) {
                        Image(localURL.path())
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 70)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                    }
                    
                    
                    if customMessage.messageType == .text {
                        Text(customMessage.message ?? "")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    } else if customMessage.messageType == .audio {
                        HStack {
                            Image(systemName: "dot.radiowaves.right")
                            Text("\(customMessage.getAudioFileDuration())s")
                            Spacer()
                        }
                        .frame(width: max(60 ,min(CGFloat(customMessage.getAudioFileDuration()) * 20, 200)))
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                    } else if  customMessage.messageType == .file  {
                        HStack {
                            Image(systemName: "filemenu.and.cursorarrow")
                            if let fileURL = customMessage.messageLocalURL {
                                ShareLink(item: fileURL) {
                                    Text(customMessage.fileName ?? "No file name")
                                }
                            }else {
                                Text(customMessage.fileName ?? "No file name")
                            }
                            Spacer()
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                    } else if customMessage.messageType == .image {
                        HStack {
                            Image(systemName: "photo")
                            if let fileURL = customMessage.messageLocalURL {
                                ShareLink(item: fileURL) {
                                    Text(customMessage.fileName ?? "No file name")
                                }
                            }else {
                                Text(customMessage.fileName ?? "No file name")
                            }
                            Spacer()
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
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
            MessageItemView(contact: contact, customMessage: message, isSender: true)
        }
    }
    
    return Preview()
}
