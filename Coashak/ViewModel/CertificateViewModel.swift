//
//  CertificateViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 09/06/2025.
//

import Foundation

@MainActor
class CertificateViewModel: ObservableObject {
    @Published var certificatesInfo: [CertificateModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    
    // Add certificate
    func addCertificate(_ certificate: CertificateModel) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await networkManager.addCertificate(certificate)
            if response.message.lowercased().contains("success") {
                // Only add the newly created certificate, no need to fetch all again
                let newCert = CertificateModel(
                    name: response.certificate.name,
                    issuingOrganization: response.certificate.issuingOrganization
                )
                certificatesInfo.append(newCert)
            } else {
                errorMessage = response.message
            }
        } catch {
            errorMessage = "Failed to add certificate: \(error.localizedDescription)"
        }

        isLoading = false
    }
    
    // Fetch certificates
    func fetchCertificates() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkManager.getcertificates()
            certificatesInfo = response.certificates.map {
                CertificateModel(name: $0.name, issuingOrganization: $0.issuingOrganization)
            }
        } catch {
            errorMessage = "Failed to fetch certificates: \(error.localizedDescription)"
            certificatesInfo = [] // Clear on error
        }
        
        isLoading = false
    }
    
    
}
