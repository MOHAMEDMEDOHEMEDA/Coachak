//
//  ContentView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var chatCoordinator = ChatCoordinator()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(chatCoordinator)
            } else {
                LoginView()
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var chatCoordinator: ChatCoordinator
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                Text("Home Screen")
                    .navigationTitle("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            // Chat Tab
            NavigationView {
                ConversationListView()
            }
            .tabItem {
                Label("Chat", systemImage: "message")
            }
            .tag(1)
            
            // Profile Tab
            NavigationView {
                VStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .padding()
                    
                    if let user = authViewModel.user {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(user.displayName ?? "Not set")")
                            Text("Email: \(user.email ?? "Not set")")
                        }
                        .padding()
                    }
                    
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(2)
        }
        .onChange(of: chatCoordinator.isShowingChatList) { isShowing in
            if isShowing {
                selectedTab = 1
                chatCoordinator.isShowingChatList = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
