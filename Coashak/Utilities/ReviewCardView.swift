//
//  ReviewCardView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 11/05/2025.
//

import SwiftUICore


// MARK: - Review Card View
struct ReviewCardView: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.reviewerName)
                .font(.headline)
                .foregroundColor(.black)

            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: index < review.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.caption) // Adjusted size to better fit card
                }
            }

            Text(review.comment)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(2) // Limit comment lines if needed
        }
        .padding()
        .background(Color(red: 0.8, green: 0.75, blue: 0.9)) // Light purple color
        .cornerRadius(12)
        .frame(width: 200) // Fixed width for horizontal scrolling, adjust as needed
    }
}
