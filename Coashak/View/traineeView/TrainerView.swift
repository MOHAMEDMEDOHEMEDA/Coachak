//
//  TrainerProfileView 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 11/05/2025.
//

import SwiftUICore
import SwiftUI
import Foundation


struct TrainerView: View {
    let id: String
    @StateObject private var viewModel = TrainerForClientsProfileViewModel()
    @State private var navigateToSubsciptionPlans = false

    var body: some View {
            Group {
                if let trainer = viewModel.trainer {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ProfileImageView(url: trainer.profilePhoto)
                            NameSection(name: trainer.fullName)
                            SectionView(title: "Bio") {
                                Text(trainer.bio ?? "")
                            }
                            SectionView(title: "Email") {
                                Text(trainer.email)
                            }

                            CertificationsSectionView(credintialId: trainer.id)
                            ExperienceFixedSection(years: trainer.yearsOfExperience ?? 0)
                            AvailabilityFixedSection(availableDays: trainer.availableDays)
                            RatingSection(rating: trainer.avgRating)

                            // ✅ Subscribe Button with navigation trigger
                            SubscribeButton(navigateToSubsciptionPlans: $navigateToSubsciptionPlans)
                        }
                        .padding(.bottom, 20)
                    }
                } else {
                    ProgressView("Loading Trainer Profile...")
                }
            }
            .onAppear {
                viewModel.fetchTrainerProfile(trainerId: id)
                print(id)
            }
            .navigationDestination(isPresented: $navigateToSubsciptionPlans) {
                if let trainer = viewModel.trainer {
                    SubscriptionPlansView(trainerId: trainer.id)
                }
            }
        
    }
}

struct ProfileImageView: View {
    let url: String
    
    var body: some View {
        AsyncImageSafe(urlString: url)
            .frame(height: 200)
    }
}
struct NameSection: View {
    let name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(name)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
    }
}
struct ExperienceFixedSection: View {
    let years: Int
    
    var body: some View {
        SectionView(title: "Experience", icon: "trophy.fill", iconColor: .yellow) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Years: \(years) years")
            }
        }
    }
}
struct RatingSection: View {
    let rating: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rated")
                .font(.headline)
                .padding(.horizontal)
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", rating))
                    .font(.headline)
            }
            .padding(.horizontal)
        }
    }
}

struct AvailabilityFixedSection: View {
    let availableDays: [String]
    
    var body: some View {
        SectionView(title: "Availability", icon: "clock", iconColor: .black) {
            let allDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            FlowLayout(spacing: 8) {
                ForEach(allDays, id: \.self) { day in
                    Text(day)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(availableDays.contains(day) ? Color.purple.opacity(0.3) : Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
    }
}
struct CertificationsSectionView: View {
    @StateObject private var viewModel = TrainerCertificateViewModel()
    let credintialId: String

    var body: some View {
        SectionView(title: "Certifications", icon: "doc.text.fill", iconColor: .gray) {
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Loading certificates...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
            } else if viewModel.certificates.isEmpty {
                Text("No certificates available.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.certificates) { cert in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Label(cert.name, systemImage: "checkmark.seal.fill")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.colorPurple)
                                    .cornerRadius(12)
                                Spacer()
                            }

                            Text("Issued by \(cert.issuingOrganization)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.top, 4)
            }
        }
        .onAppear {
            viewModel.fetchCertificates(credintialId: credintialId)
        }
    }
}


struct SubscribeButton: View {
    @Binding var navigateToSubsciptionPlans: Bool

    var body: some View {
        Button(action: {
            navigateToSubsciptionPlans = true
        }) {
            Text("Subscribtion plans")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pink.opacity(0.7))
                .cornerRadius(28)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}




// MARK: - Helper Views
struct SectionView<Content: View>: View {
    let title: String
    var icon: String? = nil
    var iconColor: Color = .black
    let content: Content
    
    init(title: String, icon: String? = nil, iconColor: Color = .black, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.headline)
            }
            
            content
        }
        .padding(.horizontal)
    }
}


// MARK: - Custom View Modifiers
struct SpecialtyTagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    init(spacing: CGFloat = 10) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentRow: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > proposal.width ?? .infinity {
                currentX = 0
                currentRow += height + spacing
                height = 0
            }
            
            currentX += size.width + spacing
            height = max(height, size.height)
            width = max(width, currentX)
        }
        
        return CGSize(width: width, height: currentRow + height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var currentX = bounds.minX
        var currentY = bounds.minY
        var rowHeight: CGFloat = 0
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                anchor: .topLeading,
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

