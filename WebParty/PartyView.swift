import SwiftUI
import ReplayKit

struct PartyView: View {
    let code: String
    let isHost: Bool

    @State private var isSharing = false
    @State private var controlState: ControlState = .none
    @State private var status = "Ready"
    @State private var showBroadcastPicker = false

    enum ControlState {
        case none, requesting, granted, denied
    }

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.04, blue: 0.06)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(code)
                            .font(.title.monospaced())
                            .foregroundStyle(.cyan)
                        Text(isHost ? "You are hosting" : "Joined as guest")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    ShareLink(item: code) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Status
                Text(status)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Main controls
                if isHost {
                    hostControls
                } else {
                    guestControls
                }

                Spacer()

                Text("Screen capture uses ReplayKit Broadcast Extension.\nSign the extension target in Xcode as well.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
        }
        .navigationTitle("Party")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private var hostControls: some View {
        VStack(spacing: 16) {
            // System Broadcast Picker (ReplayKit)
            // User starts screen share from the system UI
            BroadcastPickerRepresentable()
                .frame(height: 50)

            Text("Tap the broadcast button above to start/stop screen sharing.")
                .font(.caption)
                .foregroundStyle(.secondary)

            if controlState == .requesting {
                VStack(spacing: 12) {
                    Text("Guest is requesting control")
                        .font(.subheadline)
                        .foregroundStyle(.orange)

                    HStack(spacing: 12) {
                        Button("Accept") {
                            controlState = .granted
                            status = "Control granted to guest"
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)

                        Button("Decline") {
                            controlState = .denied
                            status = "Control request declined"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                controlState = .none
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(.orange.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            if controlState == .granted {
                Text("Guest currently has control")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var guestControls: some View {
        VStack(spacing: 16) {
            if controlState == .none || controlState == .denied {
                Button {
                    controlState = .requesting
                    status = "Control request sent..."
                    // TODO: send over signaling / WebSocket / WebRTC data channel
                } label: {
                    Label("Request Control", systemImage: "hand.raised")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            } else if controlState == .requesting {
                Text("Waiting for host...")
                    .foregroundStyle(.secondary)
            } else {
                Button {
                    controlState = .none
                    status = "Control released"
                } label: {
                    Label("Release Control", systemImage: "hand.raised.slash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.3))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }

            Text("When control is granted, touch events can be sent to the host over your signaling channel.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

/// Wraps RPSystemBroadcastPickerView so the user can start the Broadcast Upload Extension
struct BroadcastPickerRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> RPSystemBroadcastPickerView {
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        picker.preferredExtension = "com.yourteam.WebParty.BroadcastExtension" // change to your extension bundle id
        picker.showsMicrophoneButton = true
        return picker
    }

    func updateUIView(_ uiView: RPSystemBroadcastPickerView, context: Context) {}
}

#Preview {
    NavigationStack {
        PartyView(code: "ABC123", isHost: true)
    }
}
