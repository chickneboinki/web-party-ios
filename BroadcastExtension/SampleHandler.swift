import ReplayKit
import Network

/// This is the entry point for the Broadcast Upload Extension.
/// When the user starts screen sharing via RPSystemBroadcastPickerView,
/// iOS launches this extension process and feeds it CMSampleBuffers.
///
/// You must add a Broadcast Upload Extension target in Xcode and
/// set this as the principal class / sample handler.
class SampleHandler: RPBroadcastSampleHandler {

    private var isStreaming = false

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // Called when the user starts the broadcast.
        // Here you would open a connection to your signaling / media server
        // or establish a WebRTC peer connection and start sending frames.
        isStreaming = true
        NSLog("[WebParty] Broadcast started")
    }

    override func broadcastPaused() {
        NSLog("[WebParty] Broadcast paused")
    }

    override func broadcastResumed() {
        NSLog("[WebParty] Broadcast resumed")
    }

    override func broadcastFinished() {
        isStreaming = false
        NSLog("[WebParty] Broadcast finished")
        // Close connections, clean up
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard isStreaming else { return }

        switch sampleBufferType {
        case .video:
            // Encode / send the video frame to the remote peer.
            // In a full implementation you would feed this into a WebRTC
            // video source or your own encoder + network transport.
            break
        case .audioApp:
            // App audio
            break
        case .audioMic:
            // Microphone audio (if enabled in the picker)
            break
        @unknown default:
            break
        }
    }
}
