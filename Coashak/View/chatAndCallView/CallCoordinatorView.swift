//
//  CallCoordinatorView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/05/2025.
//



// CallCoordinatorView.swift
// Coashak

import SwiftUI

struct CallCoordinatorView: View {
    @ObservedObject private var agora = AgoraManager.shared
    
    // For testing, simulate users
    private let testCallee = "Alice"
    private let testCaller = "Bob"
    private let testChannelId = "coashak" // fixed channel for test
    
    var body: some View {
        Group {
            switch agora.state {
            case .idle:
                idleView
                
            case .outgoing(let callee, let channelId):
                OutgoingCallView(calleeId: callee, channelId: channelId) {
                    agora.endCall()
                }
                
            case .incoming(let caller, let channelId):
                IncomingCallView(callerName: caller) {
                    // Accept
                    agora.acceptIncomingCall()
                } onDecline: {
                    // Decline
                    agora.declineIncomingCall()
                }
                
            case .active(let participant, let channelId):
                ActiveCallView(
                    participantName: participant,
                    participantAvatarUrl: nil,
                    onEndCall: {
                        agora.endCall()
                    },
                    onMuteToggle: { mute in
                        agora.setMuted(mute)
                    },
                    onSpeakerToggle: { speakerOn in
                        agora.setSpeakerEnabled(speakerOn)
                    }
                )
            }
        }
        .animation(.default, value: agora.state)
        .padding()
    }
    
    private var idleView: some View {
        VStack(spacing: 40) {
            Spacer()
            Text("Idle - No active call")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Button("Start Outgoing Call") {
                agora.startOutgoingCall(to: testCallee, channelId: testChannelId)
            }
            .buttonStyle(.borderedProminent)
            
            Button("Simulate Incoming Call") {
                agora.simulateIncomingCall(from: testCaller, channelId: testChannelId)
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
    }
}
