//
//  FormFieldStyle.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

extension View {
    func formFieldStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2) // Light gray border
            )
            .frame(width: 343, height: 44, alignment: .center)
    }
}
