//
//  TrainerCertificateViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

    
    @MainActor
    class TrainerCertificateViewModel: ObservableObject {
        @Published var certificates: [TrainerCertificate] = []
        @Published var isLoading = false
        @Published var errorMessage: String?
        
        func fetchCertificates(credintialId: String) {
            guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/certificates/trainer-certificate") else {
                self.errorMessage = "Invalid URL"
                print("❌ Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestBody = ["credintialId": credintialId]
            do {
                request.httpBody = try JSONEncoder().encode(requestBody)
                if let json = String(data: request.httpBody!, encoding: .utf8) {
                    print("📦 Request Body: \(json)")
                }
            } catch {
                self.errorMessage = "Failed to encode request body"
                print("❌ Request encoding error:", error)
                return
            }
            
            isLoading = true
            errorMessage = nil
            print("🚀 Fetching certificates for credential ID:", credintialId)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        print("❌ Network error:", error)
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("📡 HTTP Response Code:", httpResponse.statusCode)
                    }
                    
                    guard let data = data else {
                        self.errorMessage = "No data received"
                        print("❌ No data received")
                        return
                    }
                    
                    if let rawJson = String(data: data, encoding: .utf8) {
                        print("🧾 Raw Response:\n\(rawJson)")
                    }
                    
                    do {
                        let decoded = try JSONDecoder().decode(TrainerCertificateResponse.self, from: data)
                        self.certificates = decoded.certificate
                        print("✅ Successfully decoded \(decoded.certificate.count) certificate(s)")
                    } catch {
                        self.errorMessage = "Decoding error: \(error.localizedDescription)"
                        print("❌ Decoding error:", error)
                    }
                }
            }.resume()
        }
    }

