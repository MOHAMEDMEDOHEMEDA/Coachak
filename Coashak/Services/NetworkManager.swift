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
    private let endPointForFetchUser = "users/"
    private let endPointForFetchDriver = "users/drivers/"
    private let endPointForFetchVehicle = "users/vehicles/"
    
    
    private let endPointForUpdateUser = "/api/v1/users/me"
    
    private let endPointForHealthCondition = "/api/v1/health-conditions"
    private let endPointForAllergies = "/api/v1/allergies"
    
    
    
    private let endPointForSignUp = "/api/v1/auth/register"
    private let endPointForLogIn = "/api/v1/auth/login"
    private let endPointForSendOtp = "/api/v1/auth/send-otp"
    private let endPointForVerifyEmail = "/api/v1/auth/register"
    private let endPointForPasswordReset = "/api/v1/auth/register"
    private let endPointForpasswordVerficationCode = "/api/v1/auth/register"
    private let endPointForSetNewPassword = "/api/v1/auth/register"
    private let endPointForPasswordChanging = "auth/change-password/"
    
    private let endPointForUploadImages = "/api/v1/upload"
    private let endPointForUploadVehiclesImages = "users/vehicles/upload-images/"
    private let endPointForVehiclesData = "users/vehicles/"
    
    
    
    private init() {}
    
    //    // MARK: - Fetch (Read) passenger
    //
    //    func fetchUsers(id: String) async throws -> User {
    //        // Remove the extra closing parenthesis in the URL string
    //        guard let url = URL(string: "\(baseURL)\(endPointForFetchUser)\(id)/") else {
    //            throw URLError(.badURL)
    //        }
    //
    //        // Create request with token authentication
    //        guard let request = createAuthenticatedRequest(url: url, method: "GET") else {
    //            throw URLError(.userAuthenticationRequired)
    //        }
    //
    //        // Perform network request
    //        let (data, response) = try await URLSession.shared.data(for: request)
    //
    //        // Check for valid response
    //        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        // Decode the response data into a User object (since you expect a single user)
    //        let user = try JSONDecoder().decode(User.self, from: data)
    //        return user
    //    }
    //    // MARK: - Fetch (Read) driver
    //
    //    func fetchDriver(id: String) async throws -> Driver {
    //        // Remove the extra closing parenthesis in the URL string
    //        guard let url = URL(string: "\(baseURL)\(endPointForFetchDriver)\(id)/") else {
    //            throw URLError(.badURL)
    //        }
    //
    //        // Create request with token authentication
    //        guard let request = createAuthenticatedRequest(url: url, method: "GET") else {
    //            throw URLError(.userAuthenticationRequired)
    //        }
    //
    //        // Perform network request
    //        let (data, response) = try await URLSession.shared.data(for: request)
    //
    //        // Check for valid response
    //        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        // Decode the response data into a User object (since you expect a single user)
    //        let driver = try JSONDecoder().decode(Driver.self, from: data)
    //        return driver
    //    }
    
    
    //    // MARK: - Fetch (Read) vehicle
    //
    //    func fetchVehicle(id: String) async throws -> Vehicle {
    //        // Remove the extra closing parenthesis in the URL string
    //        guard let url = URL(string: "\(baseURL)\(endPointForFetchVehicle)\(id)/") else {
    //            throw URLError(.badURL)
    //        }
    //
    //        // Create request with token authentication
    //        guard let request = createAuthenticatedRequest(url: url, method: "GET") else {
    //            throw URLError(.userAuthenticationRequired)
    //        }
    //
    //        // Perform network request
    //        let (data, response) = try await URLSession.shared.data(for: request)
    //
    //        // Check for valid response
    //        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        // Decode the response data into a User object (since you expect a single user)
    //        let vehicle = try JSONDecoder().decode(Vehicle.self, from: data)
    //        return vehicle
    //    }
    //
    //
    // MARK: - Set New Password
    func setNewPassword(email: String, newPassword: String, confirmPassword: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(endPointForSetNewPassword)") else {
            throw URLError(.badURL)
        }
        
        let passwordData = [
            "email": email,
            "password": newPassword,
            "confirm_password": confirmPassword
        ]
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the request body to JSON
        request.httpBody = try JSONSerialization.data(withJSONObject: passwordData)
        
        // Make the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check if the response is valid
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try handleError(data: data, httpResponse: response as! HTTPURLResponse)
            throw NSError(domain: "SetNewPasswordError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: errorResponse])
        }
        
        // Return success message
        return NSLocalizedString("password_reset_successful", comment: "")
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
            throw NSError(domain: "LogInError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Login failed"])
        }
        
        // Decode the response
        do {
            let successResponse = try JSONDecoder().decode(RegistrationAndLoginSuccessResponse.self, from: data)
            
            // Save token using Keychain for security
            UserDefaults.standard.set(successResponse.data.accessToken, forKey: "access_token")
            UserDefaults.standard.set(successResponse.data.refreshToken, forKey: "refresh_token")
            UserDefaults.standard.set(successResponse.data.user.email, forKey: "email")
            UserDefaults.standard.set(successResponse.data.user.password, forKey: "password")
            UserDefaults.standard.set(successResponse.data.user.firstName, forKey: "full_name")
            UserDefaults.standard.set(successResponse.data.user.id, forKey: "id")
            UserDefaults.standard.set(successResponse.data.user.role, forKey: "user_type")
            
            // Return success message and the decoded response
            return (NSLocalizedString("logged_in_successfully", comment: ""), successResponse)
            
        } catch {
            throw NSError(domain: "LogInError", code: 500, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("failed_to_decode_response", comment: "")])
        }
    }
    
    // MARK: - upload images
    func uploadImages(profilePicture: UIImage?) async throws -> String {
        
        guard let profilePicture = profilePicture else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No images to upload"])
        }
        
        // Create the URL
        guard let url = URL(string: "\(baseURL)\(endPointForUploadImages)") else {
            throw URLError(.badURL)
        }
        
        // Create an authenticated request (implement your own authentication)
        guard var request = createAuthenticatedRequest(url: url, method: "POST") else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create authenticated request"])
        }
        
        // Set multipart form boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create the multipart form data
        var body = Data()
        
        // Helper function to append images
        func appendImage(_ image: UIImage, withName name: String, fileName: String) {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        appendImage(profilePicture, withName: "profile_picture", fileName: "profile_picture.jpg")
        
        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Execute the async network call
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            // Parse JSON for imageUrl
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            if let imageUrl = json?["imageUrl"] as? String {
                return imageUrl
            } else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image URL missing in response"])
            }
        } else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Upload failed with unknown error"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }

        
        
        //    // MARK: - Upload vehicles Images
        //    func uploadVehiclesImages(
        //        licenseFront: UIImage?,
        //        licenseBack: UIImage?,
        //        photo1: UIImage?,
        //        photo2: UIImage?,
        //        photo3: UIImage?,
        //        photo4: UIImage?)
        //    async throws -> String {
        //
        //        guard let url = URL(string: "\(baseURL)\(endPointForUploadVehiclesImages)") else {
        //            throw URLError(.badURL)
        //        }
        //
        //        // Ensure there are images to upload
        //        guard licenseFront != nil || licenseBack != nil || photo1 != nil || photo2 != nil || photo3 != nil || photo4 != nil else {
        //            return "Error: No images to upload"
        //        }
        //
        //        // Create an authenticated request
        //        guard var request = createAuthenticatedRequest(url: url, method: "POST") else {
        //            return "Error: Unable to create authenticated request"
        //        }
        //
        //        // Set multipart form boundary
        //        let boundary = "Boundary-\(UUID().uuidString)"
        //        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //
        //        // Create the multipart form data
        //        var body = Data()
        //            // Helper function to append images
        //            func appendImage(_ image: UIImage, withName name: String, fileName: String) {
        //                if let imageData = image.jpegData(compressionQuality: 0.8) {
        //                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
        //                    body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        //                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        //                    body.append(imageData)
        //                    body.append("\r\n".data(using: .utf8)!)
        //                }
        //            }
        //
        //        // Append images to the request body if they are not nil
        //        if let licenseFront = licenseFront {
        //            appendImage(licenseFront, withName: "license_front", fileName: "license_front.jpg")
        //        }
        //        if let licenseBack = licenseBack {
        //            appendImage(licenseBack, withName: "license_back", fileName: "license_back.jpg")
        //        }
        //        if let photo1 = photo1 {
        //            appendImage(photo1, withName: "photo1", fileName: "photo1.jpg")
        //        }
        //        if let photo2 = photo2 {
        //            appendImage(photo2, withName: "photo2", fileName: "photo2.jpg")
        //        }
        //        if let photo3 = photo3 {
        //            appendImage(photo3, withName: "photo3", fileName: "photo3.jpg")
        //        }
        //        if let photo4 = photo4 {
        //            appendImage(photo4, withName: "photo4", fileName: "photo4.jpg")
        //        }
        //
        //        // End of the multipart form data
        //        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        //
        //        // Attach the body to the request
        //        request.httpBody = body
        //
        //        // Execute the async network call
        //        let (data, response) = try await URLSession.shared.data(for: request)
        //
        //        // Check the response status code
        //        if let httpResponse = response as? HTTPURLResponse {
        //            if httpResponse.statusCode == 200 {
        //                return "Vehicle images upload successful!"
        //            } else {
        //                let errorMessage = String(data: data, encoding: .utf8) ?? "Upload failed with unknown error"
        //                return errorMessage
        //            }
        //        } else {
        //            throw URLError(.badServerResponse)
        //        }
        //    }
        //
        //
        //    // MARK: -  Function to upload vehicle data
        //
        //    func uploadVehicleData(
        //        driverId: UUID,
        //        type: String,
        //        licenseExpiry: Date,
        //        brand: String,
        //        model: String,
        //        year: Int,
        //        color: String,
        //        vehicleClass: String,
        //        licensePlate: String
        //    ) async throws -> String {
        //
        //        // Create the URL
        //        guard let url = URL(string: "\(baseURL)\(endPointForVehiclesData)") else {
        //            throw URLError(.badURL)
        //        }
        //
        //        // Create an authenticated request
        //        guard var request = createAuthenticatedRequest(url: url, method: "POST") else {
        //            return "Error: Unable to create authenticated request"
        //        }
        //
        //        // Set the request content type to JSON
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //
        //        // Create a date formatter for formatting the date into a string
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd"
        //
        //        // Prepare the request body as a dictionary
        //        let vehicleData: [String: Any] = [
        //            "driver_id": driverId.uuidString.lowercased(),
        //            "type": type,
        //            "license_expiry": dateFormatter.string(from: licenseExpiry),
        //            "brand": brand,
        //            "model": model,
        //            "year": year,
        //            "color": color,
        //            "vehicle_class": vehicleClass,
        //            "license_plate": licensePlate
        //        ]
        //
        //        // Convert the dictionary to JSON data
        //        let jsonData = try JSONSerialization.data(withJSONObject: vehicleData, options: [])
        //
        //        // Attach the JSON data to the request
        //        request.httpBody = jsonData
        //
        //        // Log request details for debugging
        //        print("Request URL: \(url)")
        //        print("Request body: \(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")")
        //
        //        // Execute the async network call
        //        let (data, response) = try await URLSession.shared.data(for: request)
        //
        //        // Ensure the response is an HTTP response
        //        guard let httpResponse = response as? HTTPURLResponse else {
        //            throw URLError(.badServerResponse)
        //        }
        //
        //        // Handle the status code
        //        switch httpResponse.statusCode {
        //        case 200...299:
        //            // Success case: Try to decode the successful vehicle response
        //            do {
        //                let successResponse = try JSONDecoder().decode(Vehicle.self, from: data)
        //                print("Decoded vehicle: \(successResponse)")
        //
        //                // Save the vehicle ID in UserDefaults
        //                UserDefaults.standard.set(successResponse.id.uuidString, forKey: "vehicle_id")
        //
        //                // Return success message
        //                return NSLocalizedString("vehicle_data_upload_success", comment: "")
        //            } catch {
        //                print("Failed to decode successful response: \(error.localizedDescription)")
        //                throw NSError(domain: "UploadError", code: 500, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("failed_to_decode_response", comment: "")])
        //            }
        //
        //        case 400...499:
        //            // Client error: Try to decode an error message from the response
        //            if let errorMessage = String(data: data, encoding: .utf8) {
        //                print("Client error: \(errorMessage)")
        //                throw NSError(domain: "ClientError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        //            } else {
        //                throw NSError(domain: "ClientError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Client-side error occurred"])
        //            }
        //
        //        case 500...599:
        //            // Server error: Decode error message if present
        //            if let serverError = String(data: data, encoding: .utf8) {
        //                print("Server error: \(serverError)")
        //                throw NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: serverError])
        //            } else {
        //                throw NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server-side error occurred"])
        //            }
        //
        //        default:
        //            // Unexpected status code
        //            let unknownResponse = "Unexpected response code: \(httpResponse.statusCode)"
        //            print(unknownResponse)
        //            throw NSError(domain: "UnknownError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: unknownResponse])
        //        }
        //    }
        //
        //
        //    // MARK: - Get Token
        //    func getToken() -> String? {
        //        return KeychainHelper.standard.read(for: "access_token")
        //    }
        
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
            guard let url = URL(string: "\(baseURL)\(endPointForUpdateUser)") else {
                throw URLError(.badURL)
            }
            
            let request = createAuthenticatedRequest(url: url, method: "PATCH", body: requestModel)!
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "UpdateUserError",
                              code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                              userInfo: [NSLocalizedDescriptionKey: "Server error while updating user."])
            }
            print("✅ User updated successfully")
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
    }
    
    
