//
//  TestingView.swift
//  Project1
//
//  Created by BBC on 2024/6/6.
//

import SwiftUI

struct TestingView: View {
//    @State private var longPress = false
    @State var isRecording = false
    
    var body: some View {
        HStack{
            Text("Press and Hold")
            Image(systemName: "waveform")
                .symbolEffect(.bounce, options: .speed(3).repeat(isRecording ? 60 : 0), value: isRecording)
                .font(.title)
                .foregroundStyle(Color.white)
                .padding()
                .background(LinearGradient(colors: [Color.accentColor.opacity(0.5), Color.accentColor, Color.accentColor.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(Circle())
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
//        .onTapGesture {
//            isRecording.toggle()
//        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged { value in
                    if isRecording == false {
                        isRecording = true
                    }
                }
                .onEnded { value in
                    isRecording = false
                }
        )

        
        .background(isRecording ? Color.red : Color.blue)
    }
}

#Preview {
    TestingView()
}
