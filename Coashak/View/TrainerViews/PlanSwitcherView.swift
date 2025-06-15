//
//  PlanSwitcherView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 03/06/2025.
//


import SwiftUI

struct PlanSwitcherView: View {
    @State private var showingTraining: Bool = true
    let id: String
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Toggle Section
                    ToggleSection(showingTraining: $showingTraining)
                    
                    // Switched View
                    if showingTraining {
                        TrainingPlanView(id: id)
                    } else {
                        NutritionPlanView(id: id)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

