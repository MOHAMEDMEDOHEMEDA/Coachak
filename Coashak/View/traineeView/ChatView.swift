//
//  ChatView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 08/06/2025.
//



import SwiftUI

struct ChatView: View {

    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    @State private var scrollToLastMessage: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                // AI Avatar
                ZStack {
                    Circle()
                        .fill(Color.lightPurble)
                        .frame(width: 80, height: 80)

                    Image("Ai_icon")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }

                // Title and Subtitle
                VStack(spacing: 8) {
                    Text("AI Assistant")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("I am here to help you with your needs")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChatBubbleViewAi(message: message)
                                .id(message.id)
                        }

                        if viewModel.isLoading {
                            ProgressView().padding()
                        }
                    }
                    .padding(.top)
                    .onChange(of: viewModel.messages.count) { _ in
                        scrollToLastMessage = true
                    }
                    .onChange(of: scrollToLastMessage) { shouldScroll in
                        if shouldScroll, let lastID = viewModel.messages.last?.id {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    proxy.scrollTo(lastID, anchor: .bottom)
                                }
                                scrollToLastMessage = false
                            }
                        }
                    }
                }
            }

            Divider()

            HStack(spacing: 12) {
                TextField("Type a message...", text: $inputText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused($isFocused)

                Button {
                    Task {
                        await viewModel.sendMessage(inputText)
                        inputText = ""
                        scrollToLastMessage = true
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(inputText.isEmpty ? Color.gray : Color.colorPurple)
                        .clipShape(Circle())
                }
                .disabled(inputText.isEmpty)
            }
            .padding()
            .padding(.bottom, 100)
        }
        .navigationTitle("AI Chat")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End") {
                    Task {
                        await viewModel.endChat()
                    }
                }
                .foregroundStyle(Color.colorPurple)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                .foregroundStyle(Color.colorPurple)
            }
        }
    }
}

struct ChatBubbleViewAi: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            Text(message.text)
                .padding(12)
                .background(message.isUser ? Color.colorPurple : Color.colorPink.opacity(0.15))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(20)
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
