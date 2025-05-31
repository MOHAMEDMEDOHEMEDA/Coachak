//
//  CustomSegmentPicker.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    @Binding var selectedSegment: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Passenger Button
                Button(action: {
                    selectedSegment = "Sign up"
                }) {
                    Text("Sign up")
                        .foregroundColor(selectedSegment == "Sign up" ? .colorMidPink : .gray)
                        .fontWeight(selectedSegment == "Sign up" ? .bold : .regular)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                }
                
                // Driver Button
                Button(action: {
                    selectedSegment = "Log in"
                }) {
                    Text("Log in")
                        .foregroundColor(selectedSegment == "Log in" ? .colorMidPink : .gray)
                        .fontWeight(selectedSegment == "Log in" ? .bold : .regular)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                }
            }
            .background(Color.white)
            
            // Line Under Selected Segment
            HStack {
                // Show the line under the selected segment only
                Rectangle()
                    .fill(Color.colorSegment)
                    .frame(width: (UIScreen.main.bounds.width / 3)-10, height: 3) // Make the line half the screen width
                    .frame(maxWidth: .infinity, alignment: selectedSegment == "Sign up" ? .leading : .trailing)
                    .padding(.horizontal,28)
            }
            .animation(.easeInOut, value: selectedSegment)
        }
        .padding(.horizontal)
    }
}

struct ContentView: View {
    @State private var selectedSegment = "Trainee"
    
    var body: some View {
        CustomSegmentedPicker(selectedSegment: $selectedSegment)
    }
}

#Preview {
    ContentView()
}

