//
//  TraineeProfileView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 22/12/2024.
//

import SwiftUI

struct TraineeProfileView: View {
    @StateObject var viewModel = ClientProfileViewModel()

    var profileCards: [DynamicCardForTrainee] {
        [
            .init(image: "Image_2", label: "Edit Profile", destination: AnyView(EditTraineeProfileView(viewModel: viewModel).environmentObject(viewModel)), imageType: .asset)//,
//            .init(image: "Image_3", label: "Subscription Plan", destination: AnyView(()), imageType: .asset),
//            .init(image: "bell.badge.waveform", label: "Reminders", destination: AnyView(SubscriptionPlansView()), imageType: .system),
//            .init(image: "Image_4", label: "Nutrition Plan", destination: AnyView(SubscriptionPlansView()), imageType: .asset),
//            .init(image: "dumbbell", label: "Training Plan", destination: AnyView(SubscriptionPlansView()), imageType: .system),
//            .init(image: "lock", label: "Password", destination: AnyView(SubscriptionPlansView()), imageType: .system),
//            .init(image: "Image_5", label: "Logout", destination: AnyView(SubscriptionPlansView()), imageType: .asset)
        ]
    }


    var body: some View {
        NavigationStack {
            VStack {
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

                ScrollView {
                    HStack(spacing: 8) {
                        StatisticCard(value: "\(viewModel.client?.weight ?? 0)", label: "Weight", image: "calories_icon")
                        StatisticCard(value: "\(viewModel.client?.height ?? 0)", label: "Height", image: "workout_icon")
                        StatisticCard(value: "\(viewModel.client?.weightGoal ?? 0)", label: "Goal", image: "alarm_icon")
                    }
                    .padding()

                    VStack(spacing: 16) {
                        ForEach(profileCards.indices, id: \.self) { index in
                            let card = profileCards[index]
                            DynamicCardForTrainee(
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
            .onAppear {
                Task {
                    try await viewModel.fetchClientProfile()
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    private var fullName: String {
        if let user = viewModel.client {
            return "\(user.firstName) \(user.lastName)"
        } else {
            return "Loading..."
        }
    }

    // MARK: - Profile Image Section
    private var profileImageSection: some View {
        VStack {
            if let urlString = viewModel.client?.profilePhoto,
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
                    ProgressView()  // loading spinner while image loads
                        .frame(width: 150, height: 150)
                }
            } else {
                // fallback image if URL is missing or invalid
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

// MARK: - View Modifiers
extension Image {
    func profileImageStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
            .shadow(radius: 5)
    }
}

// MARK: - Card Model
struct ProfileCardItem {
    let image: String
    let label: String
    let destination: AnyView
    let imageType: DynamicCardForTrainee.ImageType
}

// MARK: - Reusable Components

struct StatisticCard: View {
    let value: String
    let label: String
    let image: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.bottom)
        }
        .frame(width: 109, height: 90)
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.colorPink, lineWidth: 1))
    }
}

struct DynamicCardForTrainee: View {
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
    TraineeProfileView()
}
