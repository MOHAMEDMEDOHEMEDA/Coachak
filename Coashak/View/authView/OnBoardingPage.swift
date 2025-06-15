//
//  SwiftUIView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//
import SwiftUI

struct OnBoardingPage: View {
    var backimageName: String
    var imageName: String
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey
    @Binding var currentTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if currentTab == 0 {
                    Image(backimageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260) // Set a fixed height
                        .frame(width: UIScreen.main.bounds.width , alignment: .trailing)
                }else if currentTab == 2{
                    Image(backimageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260) // Set a fixed height
                        .frame(width: UIScreen.main.bounds.width , alignment: .leading)
                }else{
                    Image(backimageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 260) // Set a fixed height
                        .frame(maxWidth: .infinity,alignment: .center)
                    
                }
                
                
                
                
                
                // Main image centered in the ZStack
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.top, 60) // Adjust for visual appearance
            }
            .frame(maxWidth: .infinity)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
    }
}
