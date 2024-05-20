//
//  MessageItemLocalView.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import SwiftUI

struct MessageItemLocalView: View {
    var from: String
    var message: String?
    var imageData: Data?
    var isSender: Bool
    
    var body: some View {
        if isSender {
            HStack{
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
                VStack(alignment: .leading){
                    Text("Me - \(from)")
                        .foregroundStyle(Color.accentColor)
                    
                    // Display Text
                    if let message = message {
                        Text(message)
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    
                    // Display image
                    if let imageData = imageData, let img = UIImage(data: imageData) {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                    }
                }
                Spacer()
                
            }
            .padding(.bottom, 10)
        }else {
            HStack{
                
                Spacer()
                VStack(alignment: .trailing){
                    Text(from)
                        .foregroundStyle(Color.accentColor)
                    
                    // Display text
                    if let message = message  {
                        Text(message)
                            .padding(10)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    
                    // Display image
                    if let imageData = imageData, let img = UIImage(data: imageData) {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                    }
                }
                
                Image(systemName: "person")
                    .imageScale(.large)
            }
            .padding(.bottom, 10)
        }

    }
}


//#Preview {
//    MessageItemLocalView()
//}
