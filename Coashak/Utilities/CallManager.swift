//
//  CallState.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/05/2025.
//


import AgoraRtcKit

enum CallState : Equatable {
    case idle
    case outgoing(callee: String, channelId: String)
    case incoming(caller: String, channelId: String)
    case active(participant: String, channelId: String)
}


// AgoraManager.swift
// Coashak

import Foundation
import AgoraRtcKit

class AgoraManager: NSObject, ObservableObject {
    static let shared = AgoraManager()
    
    @Published var state: CallState = .idle
    
    private var agoraEngine: AgoraRtcEngineKit?
    private let appId = "39e611a0cb4141b2b4454a8185d84606"
    private var currentChannelId: String?
    private var localUserId: UInt = UInt.random(in: 1000...9999)
    
    override private init() {
        super.init()
        initializeAgoraEngine()
    }
    
    private func initializeAgoraEngine() {
        agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        agoraEngine?.setChannelProfile(.communication)
        agoraEngine?.enableAudio()
        agoraEngine?.setDefaultAudioRouteToSpeakerphone(true)
    }

    /// Starts an outgoing call
    func startOutgoingCall(to callee: String, channelId: String = UUID().uuidString) {
        currentChannelId = channelId
        state = .outgoing(callee: callee, channelId: channelId)
        joinChannel(channelId: channelId)
    }
    
    /// Simulates an incoming call (e.g. triggered by RTM or mock)
    func simulateIncomingCall(from caller: String, channelId: String = UUID().uuidString) {
        currentChannelId = channelId
        state = .incoming(caller: caller, channelId: channelId)
    }
    
    /// Accepts an incoming call
    func acceptIncomingCall() {
        if case let .incoming(caller, channelId) = state {
            joinChannel(channelId: channelId)
            state = .active(participant: caller, channelId: channelId)
        }
    }
    
    /// Declines an incoming call
    func declineIncomingCall() {
        leaveChannel()
        state = .idle
    }
    
    /// Joins a channel with optional token
    func joinChannel(token: String? = nil, channelId: String, uid: UInt? = nil) {
        let userId = uid ?? localUserId
        agoraEngine?.joinChannel(byToken: token, channelId: channelId, info: nil, uid: userId) { [weak self] _, _, _ in
            print("✅ Joined Agora channel: \(channelId) with UID: \(userId)")
            if case let .outgoing(callee, _) = self?.state {
                self?.state = .active(participant: callee, channelId: channelId)
            }
        }
    }
    
    /// Leaves the current Agora channel
    func leaveChannel() {
        agoraEngine?.leaveChannel(nil)
        currentChannelId = nil
        print("🚪 Left Agora channel")
    }
    
    /// Ends the current call
    func endCall() {
        leaveChannel()
        state = .idle
    }
    
    /// Mutes or unmutes the local audio
    func setMuted(_ isMuted: Bool) {
        agoraEngine?.muteLocalAudioStream(isMuted)
        print("🔇 Mute: \(isMuted)")
    }
    
    /// Enables or disables speakerphone
    func setSpeakerEnabled(_ enabled: Bool) {
        agoraEngine?.setEnableSpeakerphone(enabled)
        print("🔈 Speaker: \(enabled)")
    }
}

// MARK: - AgoraRtcEngineDelegate
extension AgoraManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("🎧 Local user \(uid) joined channel \(channel)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        print("📴 Left channel with duration: \(stats.duration)s")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("👥 Remote user joined with uid: \(uid)")
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("❌ Agora error occurred: \(errorCode.rawValue)")
    }

    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("👤 Remote user \(uid) left. Reason: \(reason.rawValue)")
    }
}
