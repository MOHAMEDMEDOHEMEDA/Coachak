//
//  ClientProfileViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 03/06/2025.
//


import Foundation
import Combine

@MainActor
class ClientProfileViewModel: ObservableObject {
    @Published var client: ClientUser?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager.shared  

    func fetchClientProfile() async throws{
        isLoading = true
        errorMessage = nil
        do {
            let response = try await networkManager.fetchUser()
            self.client = response.user
            print(response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
