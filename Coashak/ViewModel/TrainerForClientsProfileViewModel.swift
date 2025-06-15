//
//  TrainerProfileViewModel 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation
import Combine
@MainActor
class TrainerForClientsViewModel: ObservableObject {
    @Published var trainers: [TrainersForClients]?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchTrainers() {
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/trainers") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let result = try JSONDecoder().decode(TrainersResponse.self, from: data)
                    self.trainers = result.trainers
                } catch {
                    self.errorMessage = "Failed to decode trainer: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
