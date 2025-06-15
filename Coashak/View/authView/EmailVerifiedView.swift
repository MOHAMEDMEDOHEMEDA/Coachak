//
//  EmailVerifiedView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/11/2024.
//

import SwiftUI

struct EmailVerifiedView: View {
    @State private var navigationTarget: String? = nil
    @EnvironmentObject var viewModel: HandleOTPViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text("Email Verified")
                    .font(.system(size: 30, weight: .bold))

                Spacer()

                Image("Email Verified Screen")
                    .resizable()
                    .scaledToFit()

                Spacer()

                Button(action: {
                    // ✅ Read role from UserDefaults
                    if let role = UserDefaults.standard.string(forKey: "user_type") {
                        navigationTarget = role
                    } else {
                        print("❌ No role found in UserDefaults")
                    }
                }) {
                    Text("Continue")
                }
                .buttonStyle(GradientButtonStyle())
                .padding(.horizontal)
                .padding(.bottom, 30)

                // ✅ Use the local state from UserDefaults
                NavigationLink(
                    destination: navigationDestinationView(for: navigationTarget),
                    isActive: Binding(
                        get: { navigationTarget != nil },
                        set: { if !$0 { navigationTarget = nil } }
                    )
                ) { EmptyView() }
                .hidden()
            }
        }
    }

    // ✅ Return view based on role
    @ViewBuilder
    func navigationDestinationView(for role: String?) -> some View {
        switch role {
        case "client":
            TraineeDataView()
                .environmentObject(viewModel)
        case "trainer":
            TrainerDetailView()
                .environmentObject(viewModel) 
        default:
            EmptyView()
        }
    }
}
