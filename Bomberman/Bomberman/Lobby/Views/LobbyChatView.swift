//
//  LobbyChatView.swift
//  Bomberman
//
//  Created by Sergey on 13.12.2025.
//

import SwiftUI

struct LobbyChatView: View {
    @ObservedObject var vm: LobbyViewModel
    @State private var messageText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            chatHeader
            chatMessagesList
            chatInputField
        }
        .background(Color.black.opacity(0.4))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var chatHeader: some View {
        HStack {
            Text("CHAT")
                .font(.kenneyFuture(size: 20))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.3))
    }
    
    private var chatMessagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(vm.chatMessages) { message in
                        ChatMessageRow(message: message, isMyMessage: message.playerID == vm.myID)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .frame(height: 200)
            .background(Color.black.opacity(0.2))
            .onChange(of: vm.chatMessages.count) { _ in
                scrollToLast(proxy: proxy)
            }
        }
    }
    
    private var chatInputField: some View {
        HStack(spacing: 8) {
            TextField("Type a message...", text: $messageText)
                .font(.kenneyFuture(size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .focused($isTextFieldFocused)
                .onSubmit {
                    sendMessage()
                }
            
            sendButton
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.3))
    }
    
    private var sendButton: some View {
        Button {
            sendMessage()
        } label: {
            Image(systemName: "paperplane.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.bombermanGreen)
                .cornerRadius(8)
        }
        .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    
    private func scrollToLast(proxy: ScrollViewProxy) {
        if let lastMessage = vm.chatMessages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        vm.sendChatMessage(trimmed)
        messageText = ""
        isTextFieldFocused = false
    }
}

struct ChatMessageRow: View {
    let message: ChatMessage
    let isMyMessage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            messageHeader
            Text(message.message)
                .font(.kenneyFuture(size: 14))
                .foregroundColor(.white)
        }
        .padding(8)
        .background(messageBackground)
        .cornerRadius(8)
    }
    
    private var messageHeader: some View {
        HStack {
            Text(message.playerName)
                .font(.kenneyFuture(size: 12))
                .foregroundColor(isMyMessage ? .yellow : .white.opacity(0.8))
            
            Spacer()
            
            Text(formatTime(message.timestamp))
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private var messageBackground: Color {
        isMyMessage ? Color.bombermanGreen.opacity(0.3) : Color.white.opacity(0.1)
    }
    
    private func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
