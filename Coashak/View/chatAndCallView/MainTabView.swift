//
//  MainTabView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/05/2025.
//


import SwiftUI

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        TabView {
            if authVM.isAuthenticated, let user = authVM.user {
                ConversationListView()
                    .tabItem {
                        Label("Chats", systemImage: "message.fill")
                    }
            } else {
                LoginViewForChat()
                    .tabItem {
                        Label("Chats", systemImage: "message.fill")
                    }
            }

            CallCoordinatorView()
                .tabItem {
                    Label("Calls Demo", systemImage: "phone.circle.fill")
                }
        }
    }
}
