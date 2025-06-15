//
//  TrainerProfileView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/04/2025.
//

import SwiftUI

struct TrainerProfileView: View {
    @StateObject var viewModel = TrainerProfileViewModel()
    @StateObject var certificateViewModel = CertificateViewModel() // New StateObject for CertificateViewModel
//       @Environment(\.dismiss) var dismiss
       
       var profileCards: [DynamicCardForTrainer] {
           [
               .init(image: "pencil", label: "Edit Profile", destination: AnyView(EditTrainerProfileView(viewModel: viewModel, certVM: certificateViewModel)), imageType: .system),
               .init(image: "Image_3", label: "Subscription Plans", destination: AnyView(TrainerSubscriptionPlansView()), imageType: .asset),
               .init(image: "person.3.fill", label: "Subscribers", destination: AnyView(YourClientsView()), imageType: .system),
               .init(image: "lock.fill", label: "Password", destination: AnyView(ForgetPasswordView()), imageType: .system),
               .init(image: "rectangle.portrait.and.arrow.right", label: "Logout", destination: AnyView(TrainerSubscriptionPlansView()), imageType: .system)
           ]
       }
    
    var body: some View {
    
            VStack(spacing: 0) {
                // Header
                ZStack {
                    VStack {
                        Text(fullName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                            .padding(.leading, 35)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200, alignment: .leading)
                    .background(Color.colorPurple)
                    .cornerRadius(130, corners: [.bottomLeft, .bottomRight])
                    .ignoresSafeArea(edges: .top)
                    
                    VStack {
                        profileImageSection
                            .frame(width: 150, height: 150)
                            .offset(y: 50)
                            .padding(.top, 30)
                    }
                }
                .frame(height: 250)
                
                ScrollView(showsIndicators: false) {
                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text(viewModel.trainer?.bio ?? "No bio provided.")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.colorPurple, lineWidth: 1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        // Settings Section
                        Text("Settings")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        
                    }
                    
                    
                    
                    VStack(alignment: .leading,spacing: 16) {
                    
                        ForEach(profileCards.indices, id: \.self) { index in
                            let card = profileCards[index]
                            DynamicCardForTrainer(
                                image: card.image,
                                label: card.label,
                                destination: card.destination,
                                imageType: card.imageType
                            )
                        }
                    }
                    .padding(.bottom, 100)
                    
                }
            }
            .ignoresSafeArea(edges: .top)
            .onAppear {
                Task {
                    try? await viewModel.fetchTrainerProfile()

                }
            }
        
    }
    
    private var fullName: String {
        if let user = viewModel.trainer {
            return "\(String(describing: user.firstName)) \(String(describing: user.lastName))"
        } else {
            return "Loading..."
        }
    }
    
    private var profileImageSection: some View {
        VStack {
            if let urlString = viewModel.trainer?.profilePhoto,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.gray)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                    .shadow(radius: 5)
            }
        }
    }
}
struct DynamicCardForTrainer: View {
    enum ImageType {
        case asset, system
    }

    let image: String
    let label: String
    let destination: AnyView
    let imageType: ImageType

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                getImageView()
                    .frame(width: 24, height: 24)
                    .padding()

                Text(label)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.colorPurple)
                    .padding()
            }
            .frame(width: 343, height: 68, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.colorPink, lineWidth: 1)
            )
        }
    }

    // MARK: - Image View
    @ViewBuilder
    private func getImageView() -> some View {
        if imageType == .system {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black)
        } else {
            Image(image)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    NavigationStack {
        TrainerProfileView()
    }
}
