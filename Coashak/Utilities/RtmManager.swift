//
//  RtmManager.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/05/2025.
//


import Foundation
import AgoraRtmKit

class RtmManager: NSObject, AgoraRtmDelegate {
    static let shared = RtmManager()

    private var rtmKit: AgoraRtmKit?
    private(set) var currentUserId: String = ""
    var onIncomingCall: ((String, String) -> Void)? // (peerId, channel)

    func initialize(appId: String, userId: String) {
        self.currentUserId = userId
        rtmKit = AgoraRtmKit(appId: appId, delegate: self)

        rtmKit?.login(byToken: nil, user: userId) { errorCode in
            if errorCode == .ok {
                print("✅ RTM login successful for \(userId)")
            } else {
                print("❌ RTM login failed: \(errorCode.rawValue)")
            }
        }
    }

    func sendCallInvite(to peerId: String, channel: String) {
        let message = AgoraRtmMessage(text: "CALL_INVITE:\(channel)")
        rtmKit?.send(message, toPeer: peerId, completion: { errorCode in
            if errorCode == .ok {
                print("📤 Call invite sent to \(peerId)")
            } else {
                print("❌ Failed to send call invite: \(errorCode.rawValue)")
            }
        })
    }
    
    func sendCallEnd(to peerId: String) {
        let message = AgoraRtmMessage(text: "CALL_ENDED")
        rtmKit?.send(message, toPeer: peerId, completion: { errorCode in
            print("📤 Sent call end to \(peerId)")
        })
    }


    // MARK: - AgoraRtmDelegate
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        let content = message.text
        if content.hasPrefix("CALL_INVITE:") {
            let channel = content.replacingOccurrences(of: "CALL_INVITE:", with: "")
            DispatchQueue.main.async {
                self.onIncomingCall?(peerId, channel)
            }
        }
    }
}

