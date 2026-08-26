import SwiftUI

struct ZyroRootView: View {
    @State private var tab = 0

    var body: some View {
        TabView(selection: $tab) {
            ZyroHomeView(tab: $tab)
                .tabItem { Label("Home", systemImage: "sparkles") }
                .tag(0)

            ZyroChatView()
                .tabItem { Label("Chat", systemImage: "bubble.left.and.bubble.right.fill") }
                .tag(1)

            ZyroCreateView()
                .tabItem { Label("Create", systemImage: "wand.and.stars") }
                .tag(2)

            ZyroDevicesView()
                .tabItem { Label("Devices", systemImage: "dot.radiowaves.left.and.right") }
                .tag(3)
        }
        .tint(.cyan)
    }
}

struct ZyroHomeView: View {
    @Binding var tab: Int

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, Color(red: 0.04, green: 0.08, blue: 0.16)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("ZYRO")
                                    .font(.system(size: 36, weight: .black, design: .rounded))
                                    .foregroundStyle(.white)
                                Text("Your AI space")
                                    .foregroundStyle(.cyan)
                            }
                            Spacer()
                            Image(systemName: "sparkles")
                                .font(.system(size: 32))
                                .foregroundStyle(.cyan)
                        }

                        Text("What do you want to do?")
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        ZyroAction(title: "Talk to Zyro", subtitle: "Ask anything with text or voice", icon: "mic.fill") {
                            tab = 1
                        }

                        ZyroAction(title: "Create", subtitle: "Make images and videos from ideas", icon: "wand.and.stars") {
                            tab = 2
                        }

                        ZyroAction(title: "Devices", subtitle: "Connect supported Bluetooth devices", icon: "dot.radiowaves.left.and.right") {
                            tab = 3
                        }

                        Text("Zyro is an independent interface. AI services are connected through your configured backend.")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .padding(.top, 12)
                    }
                    .padding(22)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ZyroAction: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(.cyan.opacity(0.15))
                    .foregroundStyle(.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                VStack(alignment: .leading) {
                    Text(title).font(.headline).foregroundStyle(.white)
                    Text(subtitle).font(.subheadline).foregroundStyle(.gray)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            .padding()
            .background(.white.opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.08)))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct ZyroChatView: View {
    @State private var text = ""
    @State private var listening = false
    @State private var messages: [(String, Bool)] = [
        ("Hey! I'm Zyro. Tell me what you need.", false)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(messages.enumerated()), id: \.offset) { _, message in
                                HStack {
                                    if message.1 { Spacer() }
                                    Text(message.0)
                                        .padding(14)
                                        .foregroundStyle(.white)
                                        .background(message.1 ? Color.cyan.opacity(0.75) : Color.white.opacity(0.09))
                                        .clipShape(RoundedRectangle(cornerRadius: 17))
                                    if !message.1 { Spacer() }
                                }
                            }
                        }
                        .padding()
                    }

                    HStack {
                        Button {
                            listening.toggle()
                        } label: {
                            Image(systemName: listening ? "stop.fill" : "mic.fill")
                                .foregroundStyle(.cyan)
                                .frame(width: 42, height: 42)
                        }

                        TextField("Ask Zyro…", text: $text, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(.white)

                        Button {
                            send()
                        } label: {
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.black)
                                .frame(width: 42, height: 42)
                                .background(.cyan)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Zyro")
            .toolbarColorScheme(.dark)
        }
    }

    func send() {
        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }
        messages.append((value, true))
        text = ""
        messages.append(("I heard you. Connect Zyro to your AI backend to enable the live response.", false))
    }
}

struct ZyroCreateView: View {
    @State private var prompt = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Create")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        Text("Turn an idea into something visual.")
                            .foregroundStyle(.gray)

                        TextField("Describe what you want to create…", text: $prompt, axis: .vertical)
                            .padding()
                            .background(.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.white)

                        HStack {
                            CreateButton(title: "Image", icon: "photo.fill")
                            CreateButton(title: "Video", icon: "film.fill")
                        }

                        Text("Image and video generation should be connected through your chosen AI provider/backend.")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                }
            }
            .navigationTitle("Create")
            .toolbarColorScheme(.dark)
        }
    }
}

struct CreateButton: View {
    let title: String
    let icon: String

    var body: some View {
        Button {
            // Connect this action to your generation backend.
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon).font(.title)
                Text(title).font(.headline)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(.cyan.opacity(0.14))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(.cyan.opacity(0.3)))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

struct ZyroDevicesView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 60))
                        .foregroundStyle(.cyan)
                    Text("Zyro Devices")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Text("Bluetooth devices can be discovered and controlled here when supported by iOS and the device.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Devices")
            .toolbarColorScheme(.dark)
        }
    }
}
