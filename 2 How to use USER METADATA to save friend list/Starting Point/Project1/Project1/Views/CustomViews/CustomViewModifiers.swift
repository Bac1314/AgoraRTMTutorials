//
//  CustomViewModifiers.swift
//  Project1
//
//  Created by BBC on 2024/5/11.
//

import SwiftUI


struct CustomRectangleOutline: ViewModifier {
    @Binding var isEditing: Bool
    
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .font(.headline)
            .padding(isEditing ? 12 : 0)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gray, lineWidth: isEditing ? 1.0 : 0.0)
            )
    }
}
