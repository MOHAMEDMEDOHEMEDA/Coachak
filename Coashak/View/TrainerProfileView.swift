//
//  TrainerProfileView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/04/2025.
//

import SwiftUI

struct TrainerProfileView: View {
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack{
            VStack {
                // Profile Header
                ZStack {
                    // Header background with text
                    VStack {
                        Text("mennatullah eslam")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                            .padding(.leading,35)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200,alignment: .leading)
                    .background(Color.colorPurple)
                    .cornerRadius(130, corners: [.bottomLeft, .bottomRight])
                    .ignoresSafeArea(edges: .top)
                    
                    // Profile Image
                    VStack {
                        profileImageSection
                            .frame(width: 150, height: 150)
                            .shadow(radius: 5)
                            .offset(y: 50)
                            .padding(.top,30)
                    }
                }
                .frame(height: 250)
                
            }
            .ignoresSafeArea(edges: .top)
            
            
            
            // Statistics Section
            ScrollView {
                HStack(spacing: 8) {
                    StatisticCard(value: "1200", label: "Calories")
                    StatisticCard(value: "5", label: "Workouts")
                    StatisticCard(value: "0", label: "Minutes")
                }
                .padding()
                
                VStack {
                    HStack {
                        Image("Image_1")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            .padding(.leading)
                        Text("Statistics")
                            .font(.system(size: 20, weight: .bold))
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                            .padding()
                    }
                    .frame(width: 343, height: 68, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.colorPink, lineWidth: 1))
                    
                    DynamicCard(image: "Image_2", label: "Edit Profile", distnation: AnyView(EditTraineeProfileView()))
                    DynamicCard(image: "Image_3", label: "Subscription Plan", distnation: AnyView(EditTraineeProfileView()))
                    DynamicCard(image: "Image_4", label: "Nutrition Plan", distnation: AnyView(EditTraineeProfileView()))
                    DynamicCard(image: "Image_5", label: "Logout", distnation: AnyView(EditTraineeProfileView()))
                }
            }
            
            
            

        }
        
    }
    // MARK: - Profile Image Section
    private var profileImageSection: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
        }
    }
}


#Preview {
    TrainerProfileView()
}
