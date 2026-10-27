import SwiftUI

struct ContentView: View {
    @State private var joinCode = ""
    @State private var showParty = false
    @State private var partyCode = ""
    @State private var isHost = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.04, blue: 0.06)
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Web Party")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .cyan.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Screen share + control requests")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)

                    // Create Party
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Create a Party", systemImage: "display")
                            .font(.headline)

                        Text("You become the host and get a short code to share.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button {
                            partyCode = generateCode()
                            isHost = true
                            showParty = true
                        } label: {
                            Text("Create Party")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Join Party
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Join a Party", systemImage: "person.2")
                            .font(.headline)

                        Text("Enter the 6-character code from the host.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField("XXXXXX", text: $joinCode)
                            .textInputAutocapitalization(.characters)
                            .multilineTextAlignment(.center)
                            .font(.title2.monospaced())
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button {
                            guard joinCode.count >= 4 else { return }
                            partyCode = joinCode.uppercased()
                            isHost = false
                            showParty = true
                        } label: {
                            Text("Join Party")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(joinCode.count < 4)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Spacer()

                    Text("Native iOS foundation. Sign & build IPA in Xcode.")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                }
                .padding()
            }
            .navigationDestination(isPresented: $showParty) {
                PartyView(code: partyCode, isHost: isHost)
            }
        }
        .preferredColorScheme(.dark)
    }

    private func generateCode() -> String {
        let chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        return String((0..<6).map { _ in chars.randomElement()! })
    }
}

#Preview {
    ContentView()
}
