//
//  RefreshTokenViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 01/06/2025.
//


import Foundation
import Combine

@MainActor
class RefreshTokenViewModel: ObservableObject {
    @Published var accessToken: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let refreshTokenKey = "refresh_token"
    private let accessTokenKey = "access_token"

    func refreshToken() async {
        isLoading = true
        errorMessage = nil

        guard let storedRefreshToken = UserDefaults.standard.string(forKey: refreshTokenKey) else {
           
                self.errorMessage = "No refresh token found in UserDefaults."
                self.isLoading = false
            
            return
        }

        let requestModel = RefreshTokenRequest(refreshToken: storedRefreshToken)

        do {
            let newAccessToken = try await NetworkManager.shared.refreshToken(refreshToken: requestModel)

            // Save the new access token
            UserDefaults.standard.setValue(newAccessToken, forKey: accessTokenKey)

            DispatchQueue.main.async {
                self.accessToken = newAccessToken
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func loadSavedAccessToken() {
        accessToken = UserDefaults.standard.string(forKey: accessTokenKey)
    }
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        accessToken = nil
    }
}
