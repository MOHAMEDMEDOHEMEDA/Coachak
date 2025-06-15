//
//  NetworkManager.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/12/2024.
//

import Foundation
import UIKit
import Security

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://coachak-backendend.onrender.com"
    private let endPointForFetchUser = "/api/v1/users/me"
    private let endPointForFetchDriver = "users/drivers/"
    private let endPointForFetchVehicle = "users/vehicles/"
    
    
    private let endPointForUpdateUser = "/api/v1/users/me"
    
    private let endPointForHealthCondition = "/api/v1/health-conditions"
    private let endPointForAllergies = "/api/v1/allergies"
    
    
    
    private let endPointForSignUp = "/api/v1/auth/register"
    private let endPointForLogIn = "/api/v1/auth/login"
    private let endPointForRefreshToken = "api/v1/auth/refresh-token"
    private let endPointForSendOtp = "/api/v1/auth/send-otp"
    private let endPointForVerifyEmail = "/api/v1/auth/register"
    private let endPointForPasswordReset = "/api/v1/auth/register"
    private let endPointForpasswordVerficationCode = "/api/v1/auth/register"
    private let endPointForSetNewPassword = "/api/v1/auth/register"
    private let endPointForPasswordChanging = "auth/change-password/"
    
    private let endPointForUploadImages = "/api/v1/upload"
    private let endPointForUploadVehiclesImages = "users/vehicles/upload-images/"
    private let endPointForVehiclesData = "users/vehicles/"
    
    private let endPointForAIMealPlan = "http://localhost:8010/api/initiate-ai-meal-plan-generation/"
    private let endPointForAISimilarMealPlan = "http://localhost:8010/api/initiate-similar-meals-recommendation/"
    private let endPointForAddingCertificate = "/api/v1/certificates"
    private let endPointForCreatingPlan = "/api/v1/plans"
    private let endPointForGettingPlans = "/api/v1/plans"
    private let endPointForGettingSubscripers = "/api/v1/subscriptions"
    private let endPointForCreatingWorkout = "/api/v1/workouts"
    private let endPointForGettingExercises = "/api/v1/exercises"

    

    
    
    private init() {}
    
    
    // MARK: - Fetch (Read) Client Profile
    func fetchUser() async throws -> ClientProfileResponse {
        print("🚀 Starting fetchUser")

        // 1. Create URL
        guard let url = URL(string: "\(baseURL)\(endPointForFetchUser)") else {
            print("❌ Invalid URL")
            throw URLError(.badURL)
        }

        // 2. Create authenticated request
        guard let request = createAuthenticatedRequest(url: url, method: "GET") else {
            print("❌ Failed to create authenticated request")
            throw URLError(.userAuthenticationRequired)
        }

        // 3. Send network request
        let (data, response) = try await URLSession.shared.data(for: request)
        print("📡 Got response from server")

        // 4. Validate response code
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Not an HTTP response")
            throw URLError(.badServerResponse)
        }

        print("🌐 Status code: \(httpResponse.statusCode)")
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ Server returned error code: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }

        // 5. Print raw JSON for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📦 Raw JSON: \(jsonString)")
        } else {
            print("❌ Couldn't convert data to string")
        }

        // 6. Decode JSON with custom date decoding
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            // Try ISO8601 with fractional seconds first
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: dateStr) {
                return date
            }

            // Fallback: try without fractional seconds
            let fallbackFormatter = ISO8601DateFormatter()
            fallbackFormatter.formatOptions = [.withInternetDateTime]
            if let fallback = fallbackFormatter.date(from: dateStr) {
                return fallback
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateStr)"
            )
        }


        do {
            let clientResponse = try decoder.decode(ClientProfileResponse.self, from: data)
            print("✅ Decoded ClientProfileResponse: \(clientResponse)")
            return clientResponse
        } catch {
            print("❌ JSON Decoding Error: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Fetch (Read) Trainer Profile
    func fetchTrainer() async throws -> TrainerProfileResponse {
        print("🚀 Starting fetchUser")

        // 1. Create URL
        guard let url = URL(string: "\(baseURL)\(endPointForFetchUser)") else {
            print("❌ Invalid URL")
            throw URLError(.badURL)
        }

        // 2. Create authenticated request
        guard let request = createAuthenticatedRequest(url: url, method: "GET") else {
            print("❌ Failed to create authenticated request")
            throw URLError(.userAuthenticationRequired)
        }

        // 3. Send network request
        let (data, response) = try await URLSession.shared.data(for: request)
        print("📡 Got response from server")

        // 4. Validate response code
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Not an HTTP response")
            throw URLError(.badServerResponse)
        }

        print("🌐 Status code: \(httpResponse.statusCode)")
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ Server returned error code: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }

        // 5. Print raw JSON for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📦 Raw JSON: \(jsonString)")
        } else {
            print("❌ Couldn't convert data to string")
        }

        // 6. Decode JSON with custom date decoding
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            // Create a new formatter instance inside the closure to avoid capture issues
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateStr)")
        }


        do {
            let trainerResponse = try decoder.decode(TrainerProfileResponse.self, from: data)
            print("✅ Decoded TrainerProfileResponse: \(trainerResponse)")
            return trainerResponse
        } catch {
            print("❌ JSON Decoding Error: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Set New Password
    func setNewPassword(email: String, newPassword: String, confirmPassword: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(endPointForSetNewPassword)") else {
            throw URLError(.badURL)
        }

        let passwordData: [String: String] = [
            "email": email,
            "password": newPassword,
            "confirm_password": confirmPassword
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONSerialization.data(withJSONObject: passwordData)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            // You can customize error handling here, parsing error details from the response if needed
            throw NSError(domain: "SetNewPasswordError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to set new password. Server returned status code \(httpResponse.statusCode)."])
        }

        return NSLocalizedString("password_reset_successful", comment: "Message shown when password reset succeeds")
    }

    //    // MARK: - Change Password
    //    func changePassword(oldPassword: String, newPassword: String, confirmNewPassword: String) async throws -> String {
    //        // Create the URL for the password change endpoint
    //        guard let url = URL(string: "\(baseURL)\(endPointForPasswordChanging)") else {
    //            throw URLError(.badURL)
    //        }
    //
    //        // Prepare the request data
    //        let passwordData: [String: Any] = [
    //            "old_password": oldPassword,
    //            "new_password": newPassword,
    //            "confirm_new_password": confirmNewPassword
    //        ]
    //
    //        // Create the authenticated request and allow modification
    //        guard var request = createAuthenticatedRequest(url: url, method: "PATCH") else {
    //            throw URLError(.userAuthenticationRequired)
    //        }
    //
    //        // Set the request header to accept JSON
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        // Encode the request body to JSON
    //        request.httpBody = try JSONSerialization.data(withJSONObject: passwordData)
    //
    //        // Make the network request
    //        let (data, response) = try await URLSession.shared.data(for: request)
    //
    //        // Check if the response status code is within the success range
    //        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
    //            let errorResponse = try handleError(data: data, httpResponse: response as! HTTPURLResponse)
    //            throw NSError(domain: "change Password Error", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: errorResponse])
    //        }
    //
    //        // Return localized success message
    //        return NSLocalizedString("password changed successfully", comment: "Message shown after successfully changing the password")
    //    }
    //
    //
    
    // MARK: - Create a new user (Sign Up)
    func signUp(user: RegistrationRequest) async throws -> RegistrationAndLoginSuccessResponse {
        guard let url = URL(string: "\(baseURL)\(endPointForSignUp)") else {
            throw URLError(.badURL)
        }
        
        var request = createRequest(url: url, method: "POST", body: user)
        request.timeoutInterval = 30 // Increase to 30s if needed
        
        
        // Perform request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RegistrationError.networkError
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            print("Response Body: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
            
            switch httpResponse.statusCode {
            case 201:
                do {
                    let successResponse = try JSONDecoder().decode(RegistrationAndLoginSuccessResponse.self, from: data)
                    
                    UserDefaults.standard.set(successResponse.data.accessToken, forKey: "access_token")
                    UserDefaults.standard.set(successResponse.data.refreshToken, forKey: "refresh_token")
                    UserDefaults.standard.set(successResponse.data.user.email, forKey: "email")
                    UserDefaults.standard.set(successResponse.data.user.password, forKey: "password")
                    UserDefaults.standard.set(successResponse.data.user.firstName, forKey: "full_name")
                    UserDefaults.standard.set(successResponse.data.user.id, forKey: "id")
                    UserDefaults.standard.set(successResponse.data.user.role, forKey: "user_type")
                    UserDefaults.standard.set(successResponse.data.user.gender, forKey: "gender")

                    
                    return successResponse
                } catch {
                    print("Decoding Success Response Failed: \(error.localizedDescription)")
                    throw RegistrationError.decodingError
                }
                
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(RegistrationErrorResponse.self, from: data)
                    throw RegistrationError.serverError(errorResponse.error)
                } catch {
                    print("Decoding Error Response Failed: \(error.localizedDescription)")
                    throw RegistrationError.decodingError
                }
                
            default:
                print("Unexpected HTTP status code: \(httpResponse.statusCode)")
                throw RegistrationError.unknownError
            }
            
        } catch let error as RegistrationError {
            throw error // Re-throw known errors
        } catch {
            if let urlError = error as? URLError {
                print("URLError code: \(urlError.code.rawValue) – \(urlError.localizedDescription)")
            } else {
                print("Unexpected error: \(error)")
            }
            throw RegistrationError.networkError
        }
    }
    
    
    
    //    // MARK: - OTP Operations
    
    func sendOtpToEmail(email: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(endPointForSendOtp)") else { throw URLError(.badURL) }
        let emailData = ["email": email]
        var request = createRequest(url: url, method: "POST", body: emailData)
        
        
        // Encode the request body
        do {
            request.httpBody = try JSONEncoder().encode(emailData)
        } catch {
            throw RegistrationError.decodingError
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return try handleError(data: data, httpResponse: response as! HTTPURLResponse)
        }
        
        return NSLocalizedString("otp_sent_successfully", comment: "")
    }
    
    // MARK: - Verify email by OTP and return role
    func verifyByOtp(otp: String) async throws -> (message: String, role: String) {
        guard let url = URL(string: "\(baseURL)\(endPointForVerifyEmail)") else {
            throw URLError(.badURL)
        }
        
        let otpData = ["otp": otp]
        let request = createRequest(url: url, method: "POST", body: otpData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return (try handleError(data: data, httpResponse: response as! HTTPURLResponse), "")
        }
        
        let decoded = try JSONDecoder().decode(VerificationResponse.self, from: data)
        return (decoded.message, decoded.role)
    }
    
    
    // MARK: - Log In
    func logIn(email: String, password: String) async throws -> (String, RegistrationAndLoginSuccessResponse) {
        guard let url = URL(string: "\(baseURL)\(endPointForLogIn)") else {
            throw URLError(.badURL)
        }

        let loginData = ["email": email, "password": password]
        let request = createRequest(url: url, method: "POST", body: loginData)
        

        let (data, response) = try await URLSession.shared.data(for: request)

        // Check for valid response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "LogInError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }

        // Check if the status code indicates success
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ HTTP Error - Code: \(httpResponse.statusCode)")
            print("❌ Response Body: \(String(data: data, encoding: .utf8) ?? "Unable to parse error response")")
            throw NSError(domain: "LogInError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Login failed"])
        }

        // Decode the response
        do {
            let successResponse = try JSONDecoder().decode(RegistrationAndLoginSuccessResponse.self, from: data)

            // Save tokens securely
            UserDefaults.standard.set(successResponse.data.accessToken, forKey: "access_token")
            UserDefaults.standard.set(successResponse.data.refreshToken, forKey: "refresh_token")
            UserDefaults.standard.set(successResponse.data.user.email, forKey: "email")
            UserDefaults.standard.set(successResponse.data.user.password, forKey: "password")
            UserDefaults.standard.set(successResponse.data.user.firstName, forKey: "full_name")
            UserDefaults.standard.set(successResponse.data.user.lastName, forKey: "last_name")
            UserDefaults.standard.set(successResponse.data.user.id, forKey: "id")
            UserDefaults.standard.set(successResponse.data.user.role, forKey: "user_type")
            UserDefaults.standard.set(successResponse.data.user.gender, forKey: "gender")
            UserDefaults.standard.set(successResponse.data.user.height, forKey: "height")
            UserDefaults.standard.set(successResponse.data.user.weight, forKey: "weight")
            UserDefaults.standard.set(successResponse.data.user.fitnessLevel, forKey: "fitness_level")
            UserDefaults.standard.set(successResponse.data.user.fitnessGoal, forKey: "fitness_goal")
            UserDefaults.standard.set(successResponse.data.user.allergy, forKey: "allergies")
            UserDefaults.standard.set(successResponse.data.user.healthCondition, forKey: "health_condition")




            return (NSLocalizedString("logged_in_successfully", comment: ""), successResponse)

        } catch {
            print("❌ LogIn Request Failed")
            print("❌ Error Type: \(type(of: error))")
            print("❌ Error: \(error.localizedDescription)")

            if let urlError = error as? URLError {
                print("❌ URLError code: \(urlError.code.rawValue) - \(urlError.code)")
            }

            throw NSError(
                domain: "LogInError",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("failed_to_decode_response", comment: "")]
            )
        }
    }

    
    // MARK: - refresh token
    func refreshToken(refreshToken: RefreshTokenRequest) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(endPointForRefreshToken)") else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url, method: "POST", body: refreshToken)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(RefreshTokenResponse.self, from: data)
        return decodedResponse.accessToken
    }
    
    
    
    // MARK: - upload images
    func uploadImages(profilePicture: UIImage?) async throws -> String {
        guard let profilePicture = profilePicture else {
            throw NSError(
                domain: "",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "No images to upload"]
            )
        }
        
        let fullURL = "\(baseURL)\(endPointForUploadImages)"
        print("➡️ [uploadImages] URL: \(fullURL)")
        guard let url = URL(string: fullURL) else {
            throw URLError(.badURL)
        }
        
        // Build a barebones authenticated request manually:
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Now set up multipart boundaries and body:
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        func appendImage(_ image: UIImage, withName name: String, fileName: String) {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append(
                "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
                    .data(using: .utf8)!
            )
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        appendImage(profilePicture, withName: "file", fileName: "profile_picture.jpg")
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // For debugging: print out roughly how large the body is:
        print("▶️ [uploadImages] Multipart body size: \(body.count) bytes")
        
        // Finally, actually make the upload call:
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("📤 [uploadImages] Status code: \(httpResponse.statusCode)")
        if httpResponse.statusCode == 200 {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            if let imageUrl = json?["data"] as? String {
                print("✅ [uploadImages] Got image URL: \(imageUrl)")
                return imageUrl
            } else {
                throw NSError(
                    domain: "",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Image URL missing in response"]
                )
            }
        } else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown upload error"
            throw NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: errorMessage]
            )
        }
    }
    
//    // MARK: - Add workout for trainer
//    func addWorkout(_ workout: WorkoutPayload) async throws -> WorkoutResponse {
//        guard let url = URL(string: "\(baseURL)\(endPointForCreatingWorkout)") else {
//            throw URLError(.badURL)
//        }
//
//
//        guard let request = createAuthenticatedRequest(url: url, method: "POST", body: workout) else {
//            throw NetworkError.invalidRequest
//        }
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.invalidResponse
//        }
//
//        guard (200...299).contains(httpResponse.statusCode) else {
//            let errorData = String(data: data, encoding: .utf8) ?? "No error details"
//            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorData)
//        }
//
//        do {
//            return try JSONDecoder().decode(WorkoutResponse.self, from: data)
//        } catch {
//            print("❌ Decoding error:", error)
//            print("📦 Raw response:", String(data: data, encoding: .utf8) ?? "Invalid data")
//            throw error
//        }
//    }
//    // MARK: - getting exercises
//    func getExercises() async throws -> ExercisesResponse {
//        
//        guard let url = URL(string: "\(baseURL)\(endPointForGettingExercises)") else {
//            throw URLError(.badURL)
//        }
//        
//        let request = createAuthenticatedRequest(url: url, method: "GET")!
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode) else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let decodedResponse = try JSONDecoder().decode(ExercisesResponse.self, from: data)
//        return decodedResponse
//    }
    // MARK: -  getting week plans
    func getDays() async throws -> MealPlanWeekResponse {
        
        guard let url = URL(string: "\(baseURL)/api/v1/subscriptions/684a2d24bd25d937647acbb9/weeks/1)") else {
            throw URLError(.badURL)
        }
        
        let request = createAuthenticatedRequest(url: url, method: "GET")!
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MealPlanWeekResponse.self, from: data)
        return decodedResponse
    }
    
//    // MARK: - Add Exercise for workout by trainer
//    func addExercise(_ exercise: ExerciseForWorkout) async throws -> WorkoutResponse {
//        guard let url = URL(string: "\(baseURL)\(endPointForCreatingWorkout)") else {
//            throw URLError(.badURL)
//        }
//
//
//        guard let request = createAuthenticatedRequest(url: url, method: "POST", body: exercise) else {
//            throw NetworkError.invalidRequest
//        }
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.invalidResponse
//        }
//
//        guard (200...299).contains(httpResponse.statusCode) else {
//            let errorData = String(data: data, encoding: .utf8) ?? "No error details"
//            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorData)
//        }
//
//        do {
//            return try JSONDecoder().decode(WorkoutResponse.self, from: data)
//        } catch {
//            print("❌ Decoding error:", error)
//            print("📦 Raw response:", String(data: data, encoding: .utf8) ?? "Invalid data")
//            throw error
//        }
//    }

    // MARK: - Add Subscription Plan for trainer
    func addPlan(_ plan: Plan) async throws -> PlanResponse {
        guard let url = URL(string: "\(baseURL)\(endPointForCreatingPlan)") else {
            throw URLError(.badURL)
        }

        guard let request = createAuthenticatedRequest(url: url, method: "POST", body: plan) else {
            throw NetworkError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorData = String(data: data, encoding: .utf8) ?? "No error details"
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorData)
        }

        let decoder = JSONDecoder()

        // ✅ Custom formatter that supports milliseconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            return try decoder.decode(PlanResponse.self, from: data)
        } catch {
            print("❌ Decoding error:", error)
            print("📦 Raw response:", String(data: data, encoding: .utf8) ?? "Invalid data")
            throw error
        }
    }

    // MARK: - Get Plans
    func getPlans() async throws -> GetPlansResponse {
        guard let url = URL(string: "\(baseURL)\(endPointForGettingPlans)") else {
            throw URLError(.badURL)
        }

        let request = createAuthenticatedRequest(url: url, method: "GET")!

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        
        // ✅ Custom formatter for fractional seconds in ISO8601
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            let decodedResponse = try decoder.decode(GetPlansResponse.self, from: data)
            return decodedResponse
        } catch {
            print("❌ Decoding error:", error)
            print("📦 Raw response:", String(data: data, encoding: .utf8) ?? "Invalid data")
            throw error
        }
    }


    // MARK: - getting subscripers
    func fetchSubscriptions() async throws -> [Subscription] {
        guard let url = URL(string: "\(baseURL)/your-endpoint-here") else {
            throw URLError(.badURL)
        }

        let request = createAuthenticatedRequest(url: url, method: "GET")!

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let responseModel = try decoder.decode(SubscriptionResponse.self, from: data)
        return responseModel.subscriptions
    }

    
    // MARK: - Add certificate for trainer
    func addCertificate(_ certificate: CertificateModel) async throws -> CertificateAddingResponse {
        guard let url = URL(string: "\(baseURL)\(endPointForAddingCertificate)") else {
            throw URLError(.badURL)
        }

        // Use correct API field names
        let requestBody: [String: String] = [
            "name": certificate.name,
            "issuingOrganization": certificate.issuingOrganization
        ]

        guard let request = createAuthenticatedRequest(url: url, method: "POST", body: requestBody) else {
            throw NetworkError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorData = String(data: data, encoding: .utf8) ?? "No error details"
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorData)
        }

        do {
            return try JSONDecoder().decode(CertificateAddingResponse.self, from: data)
        } catch {
            print("❌ Decoding error:", error)
            print("📦 Raw response:", String(data: data, encoding: .utf8) ?? "Invalid data")
            throw error
        }
    }

    // MARK: - getting certificates for trainer
    func getcertificates() async throws -> CertificateResponse {
        
        guard let url = URL(string: "\(baseURL)\(endPointForAddingCertificate)") else {
            throw URLError(.badURL)
        }
        
        let request = createAuthenticatedRequest(url: url, method: "GET")!
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(CertificateResponse.self, from: data)
        return decodedResponse
    }
    
    
    // MARK: - generate Meal plan task
       func requestMealPlanGeneration(payload: AIMealRequest) async throws -> AIMealResponse {
              guard let url = URL(string: "\(endPointForAIMealPlan)") else {
                  throw URLError(.badURL)
              }

              var request = URLRequest(url: url)
              request.httpMethod = "POST"
              request.addValue("application/json", forHTTPHeaderField: "Content-Type")

              do {
                  request.httpBody = try JSONEncoder().encode(payload)
              } catch {
                  throw NSError(domain: "EncodeError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode request payload: \(error.localizedDescription)"])
              }

              // print("Sending generation request to \(url.absoluteString) with payload: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "[payload encoding failed]")") // Removed print

              let (data, response) = try await URLSession.shared.data(for: request)

              guard let httpResponse = response as? HTTPURLResponse else {
                  throw NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response (not HTTP)"])
              }

              // print("Generation request received status code: \(httpResponse.statusCode)") // Removed print
              // if let responseString = String(data: data, encoding: .utf8) { // Removed print block
              //     print("Generation response body:\n\(responseString)")
              // }

              guard (200...299).contains(httpResponse.statusCode) else {
                   let errorDetail = String(data: data, encoding: .utf8) ?? "No details"
                   throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Meal generation request failed with status \(httpResponse.statusCode). Detail: \(errorDetail)"])
              }

              do {
                  let decodedResponse = try JSONDecoder().decode(AIMealResponse.self, from: data)
                  // print("Successfully decoded initial response: Task ID \(decodedResponse.task_id)") // Removed print
                  return decodedResponse
              } catch {
                  throw NSError(domain: "DecodeError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode initial generation response: \(error.localizedDescription)"])
              }
          }
    // MARK: - track Meal plan task status and get the result
    
    func getTaskStatus(taskId: String) async throws -> MealPlanResponse {
       guard let url = URL(string: "http://localhost:8010/api/task-status/\(taskId)/") else {
           throw URLError(.badURL)
       }

       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       // Add necessary headers if required by your API
       // request.setValue("application/json", forHTTPHeaderField: "Accept")

       // print("Polling status for Task ID \(taskId) at \(url.absoluteString)") // Removed print

       let (data, response) = try await URLSession.shared.data(for: request)

       guard let httpResponse = response as? HTTPURLResponse else {
           throw NSError(domain: "NetworkError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response during polling (not HTTP)"])
       }

       // print("Polling request received status code: \(httpResponse.statusCode)") // Removed print
       // if let responseString = String(data: data, encoding: .utf8) { // Removed print block
       //     print("Polling response body:\n\(responseString)")
       // }

       guard (200...299).contains(httpResponse.statusCode) else {
           // Handle cases where the status endpoint might return non-2xx for pending tasks differently if needed
           // For now, treat non-2xx as an error during polling.
           let errorDetail = String(data: data, encoding: .utf8) ?? "No details"
           // Distinguish this potential non-final state error
           if httpResponse.statusCode == 202 { // Example: 202 Accepted might mean pending
                throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Task status is still pending (Received \(httpResponse.statusCode)). Detail: \(errorDetail)"])
           }
           throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Polling request failed with status \(httpResponse.statusCode). Detail: \(errorDetail)"])
       }

       do {
           // Attempt to decode the *final* MealPlanResponse structure
           let decodedResponse = try JSONDecoder().decode(MealPlanResponse.self, from: data)
           // print("Successfully decoded status response. Status: \(decodedResponse.status)") // Removed print
           return decodedResponse
       } catch {
           // If decoding the final structure fails, it might still be a pending status response.
           // Check if it decodes as the *initial* AIMealResponse structure (which just has status).
           if let pendingResponse = try? JSONDecoder().decode(AIMealResponse.self, from: data) {
                // print("Decoded as pending status: \(pendingResponse.status)") // Removed print
                // Return a temporary MealPlanResponse indicating pending status
                // This requires MealPlanResponse to handle a non-final state or adjust logic.
                // For simplicity here, we'll rely on the APIError code 0 logic in pollTaskStatus.
                throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Task status is \(pendingResponse.status)."])
           }
           // If it decodes as neither, it's a true decoding error.
           throw NSError(domain: "DecodeError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode status response: \(error.localizedDescription)"])
       }
   }
    
    // MARK: - Generate Similar Meals Task
        func requestSimilarMealRecommendation(payload: MealAi) async throws -> AIMealResponse {
            guard let url = URL(string: "\(endPointForAISimilarMealPlan)") else {
                throw URLError(.badURL)
            }
            
            // The API expects the meal data nested under a "meal" key
            let requestPayload = ["meal": payload]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // Add auth if needed
            
            do {
                // Use a specific encoder if date formatting etc. is needed
                let encoder = JSONEncoder()
                // encoder.dateEncodingStrategy = .iso8601 // Example if needed
                request.httpBody = try encoder.encode(requestPayload)
            } catch {
                throw NSError(domain: "EncodeError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode similar meal request payload: \(error.localizedDescription)"])
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response (not HTTP) for similar meal request"])
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorDetail = String(data: data, encoding: .utf8) ?? "No details"
                throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Similar meal request failed with status \(httpResponse.statusCode). Detail: \(errorDetail)"])
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(AIMealResponse.self, from: data)
                return decodedResponse
            } catch {
                throw NSError(domain: "DecodeError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode initial similar meal response: \(error.localizedDescription)"])
            }
        }
        
    func getSimilarMealTaskStatus(taskId: String) async throws -> SimilarMealResponse {
        guard let url = URL(string: "http://localhost:8010/api/task-status/\(taskId)/") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Add auth if needed
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "NetworkError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response during similar meal polling (not HTTP)"])
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorDetail = String(data: data, encoding: .utf8) ?? "No details"
            if httpResponse.statusCode == 202 { // Treat 202 as pending
                throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Similar meal task status is still pending (Received \(httpResponse.statusCode)). Detail: \(errorDetail)"])
            }
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Similar meal polling request failed with status \(httpResponse.statusCode). Detail: \(errorDetail)"])
        }
        
        do {
            // Decode the UPDATED response structure for similar meals
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(SimilarMealResponse.self, from: data)
            
            // Print the decoded response here
            print("Decoded SimilarMealResponse JSON: \(String(data: try JSONEncoder().encode(decodedResponse), encoding: .utf8) ?? "Unable to encode")")

            return decodedResponse
        } catch {
            // Check if it's just a status update without the full result yet
            if let pendingResponse = try? JSONDecoder().decode(AIMealResponse.self, from: data) {
                throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Similar meal task status is \(pendingResponse.status)."])
            }
            // Print decoding error for debugging
            print("Decoding Error in getSimilarMealTaskStatus: \(error)")
            print("Raw data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
            throw NSError(domain: "DecodeError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode similar meal status response: \(error.localizedDescription)"])
        }
    }

        
   
    
    // MARK: - Password sent code for verification
    
    func sendCodeForPasswordReset(email: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(endPointForPasswordReset)") else { throw URLError(.badURL) }
        let emailData = ["email": email]
        let request = createRequest(url: url, method: "POST", body: emailData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return try handleError(data: data, httpResponse: response as! HTTPURLResponse)
        }
        
        return NSLocalizedString("code_sent_successfully", comment: "")
    }
    
    // MARK: - Password restore by email
    
    func passwordVerificationCode(code: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(endPointForpasswordVerficationCode)") else { throw URLError(.badURL) }
        let codeData = ["code": code]
        let request = createRequest(url: url, method: "POST", body: codeData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return try handleError(data: data, httpResponse: response as! HTTPURLResponse)
        }
        
        return NSLocalizedString("code_verified_successfully", comment: "")
    }
    
    // MARK: - Update an existing user
    func updateUser(_ requestModel: Client) async throws {
        // 1) Build the URL
        let fullURLString = "\(baseURL)\(endPointForUpdateUser)"
        print("▶️ [UpdateUser] full URL string: \(fullURLString)")
        guard let url = URL(string: fullURLString) else {
            throw URLError(.badURL)
        }
        
        // 2) Create the URLRequest via your helper
        guard let request = createAuthenticatedRequest(
            url: url,
            method: "PATCH",
            body: requestModel
        ) else {
            throw NSError(
                domain: "UpdateUserError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to create authenticated request."]
            )
        }
        
        // 3) Print out everything on that URLRequest
        print("▶️ [UpdateUser] HTTP Method: \(request.httpMethod ?? "nil")")
        print("▶️ [UpdateUser] URL: \(request.url?.absoluteString ?? "nil")")
        print("▶️ [UpdateUser] All HTTP Headers:")
        request.allHTTPHeaderFields?.forEach { key, value in
            print("    \(key): \(value)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("▶️ [UpdateUser] HTTP Body:\n\(bodyString)")
        } else {
            print("▶️ [UpdateUser] HTTP Body is nil or cannot be stringified.")
        }
        
        // 4) Perform the network call
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // 5) Inspect the HTTP status
        if (200...299).contains(httpResponse.statusCode) {
            print("✅ [UpdateUser] Success, status \(httpResponse.statusCode)")
        } else {
            let serverMessage = String(data: data, encoding: .utf8) ?? "No message"
            throw NSError(
                domain: "UpdateUserError",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Server error (\(httpResponse.statusCode)): \(serverMessage)"
                ]
            )
        }
    }
    
    func updateTrainer<T: Codable>(_ requestModel: T) async throws {
            let fullURLString = "\(baseURL)\(endPointForUpdateUser)"
            print("▶️ [UpdateUser] full URL string: \(fullURLString)")

            guard let url = URL(string: fullURLString) else {
                throw URLError(.badURL)
            }

            guard let request = createAuthenticatedRequest(
                url: url,
                method: "PATCH",
                body: requestModel
            ) else {
                throw NSError(
                    domain: "UpdateUserError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to create authenticated request."]
                )
            }

            print("▶️ [UpdateUser] HTTP Method: \(request.httpMethod ?? "nil")")
            print("▶️ [UpdateUser] URL: \(request.url?.absoluteString ?? "nil")")
            request.allHTTPHeaderFields?.forEach { key, value in
                print("    \(key): \(value)")
            }
            if let body = request.httpBody,
               let bodyString = String(data: body, encoding: .utf8) {
                print("▶️ [UpdateUser] HTTP Body:\n\(bodyString)")
            } else {
                print("▶️ [UpdateUser] HTTP Body is nil or cannot be stringified.")
            }

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            if (200...299).contains(httpResponse.statusCode) {
                print("✅ [UpdateUser] Success, status \(httpResponse.statusCode)")
            } else {
                let serverMessage = String(data: data, encoding: .utf8) ?? "No message"
                throw NSError(
                    domain: "UpdateUserError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Server error (\(httpResponse.statusCode)): \(serverMessage)"]
                )
            }
        }
    
    
    
    //    // MARK: - Delete a user
    //    func deleteUser(withID id: UUID) async throws {
    //        guard let url = URL(string: "\(baseURL)users/\(id)") else { throw URLError(.badURL) }
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "DELETE"
    //
    //        let (_, response) = try await URLSession.shared.data(for: request)
    //        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
    //            throw NSError(domain: "DeleteUserError", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("server_error", comment: "")])
    //        }
    //    }
    //
    
    
    // MARK: - healthCondition
    
    func addHealthCondition(_ healthCondition: HealthConditionAndAllergies) async throws -> HealthConditionAndAllergies {
        
        guard let url = URL(string: "\(baseURL)\(endPointForHealthCondition)") else {
            throw URLError(.badURL)
        }
        
        let request = createAuthenticatedRequest(url: url, method: "POST", body: healthCondition)!
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(HealthConditionAndAllergies.self, from: data)
        return decodedResponse
    }
    
    
    // MARK: - getting health condition
    
    func gethealthCondition() async throws -> [HealthConditionAndAllergies] {
        
        guard let url = URL(string: "\(baseURL)\(endPointForHealthCondition)") else {
            throw URLError(.badURL)
        }
        
        let request = createAuthenticatedRequest(url: url, method: "GET")!
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode([HealthConditionAndAllergies].self, from: data)
        return decodedResponse
    }
    
    
    
    
    // MARK: - allergies
    
    func addAllergies(_ allergies: HealthConditionAndAllergies) async throws -> HealthConditionAndAllergies {
        
        guard let url = URL(string: "\(baseURL)\(endPointForHealthCondition)") else {
            throw URLError(.badURL)
        }
        
        let request = createAuthenticatedRequest(url: url, method: "POST", body: allergies)!
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(HealthConditionAndAllergies.self, from: data)
        return decodedResponse
    }
    
    func getAllergies() async throws -> [HealthConditionAndAllergies] {
        
        guard let url = URL(string: "\(baseURL)\(endPointForAllergies)") else {
            throw URLError(.badURL)
        }
        
        let request = createAuthenticatedRequest(url: url, method: "GET")!
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode([HealthConditionAndAllergies].self, from: data)
        return decodedResponse
    }
    
    
    // MARK: - Helper Functions
    func createAuthenticatedRequest<T: Codable>(url: URL, method: String, body: T?) -> URLRequest? {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            print("Token not available")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        
        return request
    }
    
    
    func createAuthenticatedRequest(url: URL, method: String) -> URLRequest? {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            print("Token not available")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    
    
    // Create URLRequest with necessary headers and JSON body
    private func createRequest<T: Encodable>(url: URL, method: String, body: T) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
    
    // Handle error messages from server
    private func handleError(data: Data, httpResponse: HTTPURLResponse) throws -> String {
        // Try decoding the server response for a general error
        if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
            var errorMessages = [String]()
            
            // Check if there's a general error message
            if let detail = errorResponse.detail {
                errorMessages.append(detail)
            }
            
            // Check for specific field errors
            if let errors = errorResponse.errors {
                for (field, messages) in errors {
                    let formattedMessages = messages.joined(separator: ", ")
                    errorMessages.append("\(field.capitalized): \(formattedMessages)")
                }
            }
            
            return errorMessages.joined(separator: "\n")
        } else {
            return NSLocalizedString("server_error", comment: "")
        }
    }
    //   private func convertImageToBase64String(image: UIImage) -> String {
    //        if let imageData = image.jpegData(compressionQuality: 0.8) {
    //            return imageData.base64EncodedString()
    //        }
    //        return ""
    //    }
    enum NetworkError: Error {
        case badURL
        case invalidRequest
        case invalidResponse
        case serverError(statusCode: Int, message: String)
        case decodingError
    }

}



