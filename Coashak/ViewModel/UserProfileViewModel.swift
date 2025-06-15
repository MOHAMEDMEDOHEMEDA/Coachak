//
//  UserProfileViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//


import Foundation
import Combine

class UserProfileViewModel: ObservableObject {
    @Published var trainee: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()

    func fetchUserProfile(userId: String) {
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/users/\(userId)") else {
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
                            let result = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                            self.trainee = result.user
                        } catch {
                            self.errorMessage = "Failed to decode user: \(error.localizedDescription)"
                        }
                    }
                }.resume()
            }
        }
