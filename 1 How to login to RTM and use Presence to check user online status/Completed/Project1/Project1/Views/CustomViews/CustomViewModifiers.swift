//
//  CustomViewModifiers.swift
//  Project1
//
//  Created by BBC on 2024/5/11.
//

import SwiftUI


struct CustomRectangleOutline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .font(.headline)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.gray, lineWidth: 1.0)
            )
    }
}
