//
//  CustomPickerPopUp.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/12/2024.
//

import SwiftUI

struct CustomPickerPopupView: View {
    let title: String
    let range: ClosedRange<Int>
    let units: [String]
    @Binding var selection: Int
    @Binding var selectedUnit: String
    var onDismiss: () -> Void // Added closure
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Header with Close and Confirm Buttons
                HStack {
                    Button(action: {
                        onDismiss() // Call the closure instead of dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color.purple)
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        onDismiss() // Call the closure instead of dismiss()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color.purple)
                    }
                }
                .padding()
                
                HStack {
                    // Picker for the range (numeric values)
                    Picker("", selection: $selection) {
                        ForEach(range, id: \.self) { value in
                            Text("\(value)")
                                .font(.title3)
                                .tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 130, height: 400)
                    .clipped()
                    
                    // Picker for the units
                    Picker("", selection: $selectedUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                                .font(.title3)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80, height: 300)
                    .clipped()
                }
                
                Spacer()
            }
            .frame(width: 350, height: 300) // Adjust the size of the popup
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }
}
