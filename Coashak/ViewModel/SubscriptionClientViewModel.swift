//
//  SubscriptionViewModel 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

class SubscriptionClientViewModel: ObservableObject {
    private var session: URLSession

    @Published var subscription: SubscriptionClient?
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(session: URLSession = .shared) {
        self.session = session
    }

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

        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(SubscriptionClientResponse.self, from: data)
                        self.subscription = decoded.subscription
                        completion(.success(decoded.message))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "No response data"])))
                }
            }
        }.resume()
    }
}
