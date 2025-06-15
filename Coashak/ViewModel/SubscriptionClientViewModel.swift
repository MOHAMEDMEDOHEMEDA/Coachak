//
//  SubscriptionViewModel 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

class SubscriptionClientViewModel: ObservableObject {
    @Published var subscription: SubscriptionClient?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func subscribeToPlan(planId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/subscriptions") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Token missing"])))
            return
        }

        let body = ["plan": planId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid request body"])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status Code: \(httpResponse.statusCode)")
                    print("📎 Headers: \(httpResponse.allHeaderFields)")
                }

                if let data = data {
                    print("🧾 Raw Response:")
                    if let rawString = String(data: data, encoding: .utf8) {
                        print(rawString)
                    } else {
                        print("⚠️ Unable to decode response as UTF-8 string.")
                    }

                    do {
                        let decoded = try JSONDecoder().decode(SubscriptionClientResponse.self, from: data)
                        self.subscription = decoded.subscription
                        completion(.success(decoded.message))
                    } catch {
                        print("❌ Decoding error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                } else {
                    print("⚠️ No data received.")
                    completion(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "No response data"])))
                }
            }
        }.resume()
    }

}
