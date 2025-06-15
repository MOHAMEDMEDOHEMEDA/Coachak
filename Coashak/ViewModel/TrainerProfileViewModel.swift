//
//  TrainerProfileViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//

import Foundation
import Combine

@MainActor
class TrainerProfileViewModel: ObservableObject {
    @Published var trainer: TrainerUser?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager.shared

    func fetchTrainerProfile() async throws{
        isLoading = true
        errorMessage = nil
        do {
            let response = try await networkManager.fetchTrainer()
            self.trainer = response.user
            print(response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
