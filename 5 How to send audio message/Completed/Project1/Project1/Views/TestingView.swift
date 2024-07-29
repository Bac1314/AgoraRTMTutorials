//
//  TestingView.swift
//  Project1
//
//  Created by BBC on 2024/6/6.
//

import SwiftUI

struct TestingView: View {

    @State var textValue : String = ""
    @State var textValue2 : String = ""
    @State var textValue3 : String = ""
    @State var textValue4 : String = ""
    @State var textValue5 : String = ""
    @State var isEditing : Bool = true
    
    var body: some View {
        ScrollView {
            Text("HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD ")
                .font(.headline)
            
            Spacer(minLength: 150)
            
            VStack(alignment: .leading, spacing: 6){
                Text("textValue")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $textValue)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            
            VStack(alignment: .leading, spacing: 6){
                Text("textValue2")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $textValue2)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            
            
            VStack(alignment: .leading, spacing: 6){
                Text("textValue3")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $textValue3)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            
            VStack(alignment: .leading, spacing: 6){
                Text("textValue4")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $textValue4)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            
            
            
            VStack(alignment: .leading, spacing: 6){
                Text("textValue5")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                TextField("", text: $textValue5)
                    .modifier(CustomRectangleOutline(isEditing: $isEditing))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            
            Spacer(minLength: 250)

        }
    }
}

#Preview {
    TestingView()
}
