//
//  IncomingCallView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/05/2025.
//


import SwiftUI


// MARK: - Incoming Call View
struct IncomingCallView: View {
    let callerName: String
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.gray)
            
            Text(callerName)
                .font(.largeTitle)
                .fontWeight(.medium)
            
            Text("Incoming Voice Call")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Spacer()
            
            HStack(spacing: 60) {
                Button(action: {
                    onDecline()
                }) {
                    VStack {
                        Image(systemName: "phone.down.fill")
                            .font(.title)
                            .padding(20)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        Text("Decline")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button(action: {
                    onAccept()
                    AgoraManager.shared.joinChannel(
                        token: nil ,
                        channelId: "coashak",
                        uid: 1234
                    )
                }) {
                    VStack {
                        Image(systemName: "phone.fill")
                            .font(.title)
                            .padding(20)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        Text("Accept")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Outgoing Call View
struct OutgoingCallView: View {
    let calleeId: String
    let channelId: String
    let onEndCall: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.gray)
            
            Text(calleeId)
                .font(.largeTitle)
                .fontWeight(.medium)
            
            Text("Calling...")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                onEndCall()
                AgoraManager.shared.leaveChannel()
            }) {
                VStack {
                    Image(systemName: "phone.down.fill")
                        .font(.title)
                        .padding(25)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    Text("End Call")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .onAppear {
            RtmManager.shared.sendCallInvite(to: calleeId, channel: channelId)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}



// MARK: - Active Call View
struct ActiveCallView: View {
    let participantName: String
    let participantAvatarUrl: URL?
    
    @State private var callDuration: TimeInterval = 0
    @State private var isMuted: Bool = false
    @State private var isSpeakerOn: Bool = false
    
    let onEndCall: () -> Void
    let onMuteToggle: (Bool) -> Void
    let onSpeakerToggle: (Bool) -> Void
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text(participantName)
                .font(.title2)
                .fontWeight(.medium)
            
            Text(formatDuration(callDuration))
                .font(.title3)
                .foregroundColor(.secondary)
                .onReceive(timer) { _ in
                    callDuration += 1
                }
            
            Spacer()
            
            HStack(spacing: 40) {
                CallControlButton(systemName: isMuted ? "mic.slash.fill" : "mic.fill", label: "Mute", isOn: $isMuted) {
                    isMuted.toggle()
                    onMuteToggle(isMuted)
                }
                
                CallControlButton(systemName: isSpeakerOn ? "speaker.wave.2.fill" : "speaker.fill", label: "Speaker", isOn: $isSpeakerOn) {
                    isSpeakerOn.toggle()
                    onSpeakerToggle(isSpeakerOn)
                }
            }
            
            Button(action: {
                onEndCall()
            }) {
                VStack {
                    Image(systemName: "phone.down.fill")
                        .font(.title)
                        .padding(25)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    Text("End Call")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "00:00"
    }
}

struct CallControlButton: View {
    let systemName: String
    let label: String
    @Binding var isOn: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemName)
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .background(isOn ? Color.gray.opacity(0.5) : Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .clipShape(Circle())
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

