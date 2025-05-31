//
//  CoashakApp.swift
//  Coashak
//
//  Created by Mohamed Magdy on 25/10/2024.
//

import SwiftUI
import SwiftData
import Firebase



@main
struct CoashakApp: App {
    
    init() {
            FirebaseApp.configure()
        }



    var body: some Scene {
        WindowGroup {
                    OnBoardingView()
                        .environmentObject(AuthViewModel()) 
                }
    }
}
