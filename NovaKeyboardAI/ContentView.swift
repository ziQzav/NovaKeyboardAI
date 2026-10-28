import SwiftUI

struct ContentView: View {
    @State private var nativeLanguage: String = "Turkish"
    @State private var targetLanguage: String = "English"
    @State private var keyboardLayout: String = "Turkish"
    
    // Customization
    @State private var keyboardHeight: Double = 216
    @State private var keyHeight: Double = 42
    @State private var fontSize: Double = 22
    @State private var keySounds: Bool = true
    @State private var hapticFeedback: Bool = true
    @State private var apiBaseURL: String = ""
    @State private var apiModel: String = ""
    @State private var apiKey: String = ""
    @State private var actions: [NovaAction] = NovaAction.defaults
    @State private var shortcuts: [String: String] = [:]
    @State private var newTrigger: String = ""
    @State private var newReplacement: String = ""
    
    @State private var testText = ""
    @State private var testResult = ""
    @State private var testLatency = ""
    
    let layouts = ["Turkish", "English", "AZERTY", "QWERTZ", "Spanish", "Portuguese", "Italian"]
    let languages = ["Turkish", "English", "German", "French", "Spanish", "Arabic", "Russian", "Chinese", "Japanese", "Korean", "Italian", "Portuguese", "Dutch"]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.15, green: 0.05, blue: 0.3)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(red: 0.35, green: 0.2, blue: 0.8), Color(red: 0, green: 0.8, blue: 0.85)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 90, height: 90)
                                .blur(radius: 20)
                            Image(systemName: "keyboard.badge.globe")
                                .font(.system(size: 45))
                                .foregroundColor(.white)
                        }
                        
                        Text("Nova Keyboard AI")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("AI-Powered Keyboard & Translator")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 30)
                    
                    // Full Access Info Card
                    HStack(spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Full Access Required for AI Features")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                            Text("Settings → General → Keyboard → Keyboards → Nova Keyboard AI → Allow Full Access")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0, green: 0.8, blue: 0.85).opacity(0.3), lineWidth: 1))
                    .padding(.horizontal, 16)
                    
                    // Keyboard Size Customization
                    settingsCard(title: "Keyboard Size", icon: "slider.horizontal.3") {
                        VStack(spacing: 14) {
                            sliderRow(label: "Keyboard Height", value: $keyboardHeight, range: 180...300, unit: "pt")
                            sliderRow(label: "Key Height", value: $keyHeight, range: 30...54, unit: "pt")
                            sliderRow(label: "Font Size", value: $fontSize, range: 14...28, unit: "pt")
                            
                            // Preview
                            HStack(spacing: 3) {
                                ForEach(["Q","W","E","R","T"], id: \.self) { key in
                                    Text(key)
                                        .font(.system(size: CGFloat(fontSize), design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: CGFloat(keyHeight))
                                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.15)))
                                }
                            }
                            .padding(.top, 4)
                            
                            Text("↑ Live Preview")
                                .font(.system(size: 9)).foregroundColor(Color(red: 0, green: 0.8, blue: 0.85).opacity(0.6))
                        }
                    }
                    
                    // Sound & Haptic
                    settingsCard(title: "Sound & Haptic", icon: "speaker.wave.2") {
                        VStack(spacing: 12) {
                            Toggle(isOn: $keySounds) {
                                HStack {
                                    Image(systemName: "speaker.wave.1").foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
                                    Text("Key Sounds").foregroundColor(.white.opacity(0.8))
                                }
                            }.accentColor(Color(red: 0, green: 0.8, blue: 0.85))
                            
                            Toggle(isOn: $hapticFeedback) {
                                HStack {
                                    Image(systemName: "iphone.radiowaves.left.and.right").foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
                                    Text("Haptic Feedback").foregroundColor(.white.opacity(0.8))
                                }
                            }.accentColor(Color(red: 0, green: 0.8, blue: 0.85))
                        }
                    }
                    
                    // Keyboard Layout
                    settingsCard(title: "Keyboard Layout", icon: "keyboard") {
                        VStack(spacing: 10) {
                            HStack {
                                Text("Current Layout").foregroundColor(.white.opacity(0.7)).font(.subheadline)
                                Spacer()
                                Picker("Layout", selection: $keyboardLayout) {
                                    ForEach(layouts, id: \.self) { Text($0) }
                                }
                                .pickerStyle(.menu)
                                .accentColor(Color(red: 0, green: 0.8, blue: 0.85))
                            }
                            
                            Text(getLayoutPreview())
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }

                    
                    // Translation Settings
                    settingsCard(title: "Translation", icon: "globe") {
                        VStack(spacing: 12) {
                            HStack {
                                Text("I speak").foregroundColor(.white.opacity(0.7)).font(.subheadline)
                                Spacer()
                                Picker("", selection: $nativeLanguage) {
                                    ForEach(languages, id: \.self) { Text($0) }
                                }.accentColor(Color(red: 0, green: 0.8, blue: 0.85))
                            }
                            
                            HStack {
                                Text("Translate to").foregroundColor(.white.opacity(0.7)).font(.subheadline)
                                Spacer()
                                Picker("", selection: $targetLanguage) {
                                    ForEach(languages, id: \.self) { Text($0) }
                                }.accentColor(Color(red: 0, green: 0.8, blue: 0.85))
                            }
                            
                            HStack {
                                Image(systemName: "arrow.right").foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
                                Text("\(nativeLanguage) → \(targetLanguage)")
                                    .font(.caption).foregroundColor(Color(red: 0, green: 0.8, blue: 0.85)).bold()
                            }
                        }
                    }
                    
                    // AI Configuration (any OpenAI-compatible endpoint)
                    settingsCard(title: "AI Endpoint", icon: "cpu") {
                        VStack(spacing: 12) {
                            TextField("Base URL (https://api.openai.com/v1)", text: $apiBaseURL)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.white)

                            TextField("Model (gpt-4o-mini, llama-3.3-70b-versatile, ...)", text: $apiModel)
                                .textFieldStyle(PlainTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.white)

                            SecureField("API Key (leave empty for a local server)", text: $apiKey)
                                .textFieldStyle(PlainTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.white)

                            Button {
                                runTest(isTranslate: false)
                            } label: {
                                HStack {
                                    Image(systemName: "bolt.horizontal.circle")
                                    Text("Test Connection")
                                }
                                .font(.system(size: 15, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color(red: 0, green: 0.8, blue: 0.85))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                            }

                            if !testResult.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(testResult)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(testResult.hasPrefix("Error") ? .orange : .green)
                                        .fixedSize(horizontal: false, vertical: true)
                                    if !testLatency.isEmpty {
                                        Text(testLatency)
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Text("Any OpenAI-compatible /chat/completions server works: OpenAI, Groq, OpenRouter, Ollama, LM Studio, or your own. The key stays on the device.")
                                .font(.system(size: 10))
                                .foregroundColor(.orange.opacity(0.85))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    // Configurable AI buttons
                    settingsCard(title: "AI Buttons", icon: "square.grid.2x2") {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Up-swipe opens these buttons on the keyboard. {{TEXT}} {{LANG}} {{TARGET}} {{TONE}} are replaced at run time.")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.45))
                                .fixedSize(horizontal: false, vertical: true)

                            ForEach(actions.indices, id: \.self) { i in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Toggle(isOn: $actions[i].enabled) {
                                            TextField("Title", text: $actions[i].title)
                                                .textFieldStyle(PlainTextFieldStyle())
                                                .foregroundColor(.white)
                                                .autocapitalization(.none)
                                        }
                                        .accentColor(Color(red: 0, green: 0.8, blue: 0.85))

                                        Button {
                                            actions.remove(at: i)
                                            NovaActionStore.save(actions)
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red.opacity(0.8))
                                        }
                                    }

                                    TextEditor(text: $actions[i].prompt)
                                        .font(.system(size: 11, design: .monospaced))
                                        .frame(height: 78)
                                        .padding(6)
                                        .background(Color.white.opacity(0.08))
                                        .cornerRadius(6)
                                        .foregroundColor(.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                }
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(10)
                            }

                            HStack(spacing: 10) {
                                Button {
                                    actions.append(NovaAction(
                                        title: "New",
                                        prompt: "Do something with this text and return ONLY the result:\n\n{{TEXT}}"
                                    ))
                                    NovaActionStore.save(actions)
                                } label: {
                                    Label("Add", systemImage: "plus.circle.fill")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
                                }

                                Spacer()

                                Button {
                                    actions = NovaAction.defaults
                                    NovaActionStore.save(actions)
                                } label: {
                                    Label("Reset", systemImage: "arrow.counterclockwise")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                    }

                    // Text Shortcuts
                    settingsCard(title: "Text Shortcuts", icon: "bolt.fill") {
                        VStack(spacing: 10) {
                            HStack(spacing: 8) {
                                TextField("Trigger (@@)", text: $newTrigger)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(8)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                    .frame(width: 100)
                                TextField("Replacement", text: $newReplacement)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(8)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                Button {
                                    if !newTrigger.isEmpty && !newReplacement.isEmpty {
                                        shortcuts[newTrigger] = newReplacement
                                        newTrigger = ""
                                        newReplacement = ""
                                        saveShortcuts()
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
                                        .font(.title2)
                                }
                            }
                            
                            ForEach(Array(shortcuts.keys.sorted()), id: \.self) { key in
                                HStack {
                                    Text(key).font(.caption).bold().foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
                                    Image(systemName: "arrow.right").font(.system(size: 8)).foregroundColor(.white.opacity(0.3))
                                    Text(shortcuts[key] ?? "").font(.caption).foregroundColor(.white.opacity(0.7)).lineLimit(1)
                                    Spacer()
                                    Button {
                                        shortcuts.removeValue(forKey: key)
                                        saveShortcuts()
                                    } label: {
                                        Image(systemName: "trash").font(.caption).foregroundColor(.red.opacity(0.6))
                                    }
                                }
                            }
                            
                            if shortcuts.isEmpty {
                                Text("Add shortcuts like @@ \u{2192} your@email.com")
                                    .font(.system(size: 10)).foregroundColor(.white.opacity(0.3))
                            }
                        }
                    }
                    
                    // Test Area
                    settingsCard(title: "Test Area", icon: "flask") {
                        VStack(spacing: 10) {
                            TextField("Type text to test", text: $testText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                            
                            HStack {
                                Button("Translate") { runTest(isTranslate: true) }
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(Color(red: 0, green: 0.8, blue: 0.85))
                                    .foregroundColor(.black).cornerRadius(6)
                                Button("Spell Check") { runTest(isTranslate: false) }
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(Color.orange)
                                    .foregroundColor(.white).cornerRadius(6)
                            }
                            
                            if !testResult.isEmpty {
                                Text(testResult)
                                    .font(.system(size: 14))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                            if !testLatency.isEmpty {
                                Text(testLatency)
                                    .font(.caption).foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // Gestures Guide
                    settingsCard(title: "Gestures", icon: "hand.draw") {
                        VStack(alignment: .leading, spacing: 8) {
                            GestureRow(icon: "arrow.down", color: Color(red: 0.35, green: 0.2, blue: 0.8), title: "Swipe Down", desc: "Translate text")
                            GestureRow(icon: "arrow.up", color: Color(red: 0, green: 0.8, blue: 0.85), title: "Swipe Up", desc: "AI Tone Shift")
                            GestureRow(icon: "arrow.left", color: .orange, title: "Swipe Left", desc: "AI Spell Check")
                            GestureRow(icon: "hand.point.right", color: .green, title: "Space Bar Drag", desc: "Move cursor")
                        }
                    }
                    
                    // Setup Steps
                    settingsCard(title: "Setup", icon: "gearshape.2") {
                        VStack(alignment: .leading, spacing: 8) {
                            SetupStep(n: "1", t: "Settings > General > Keyboard")
                            SetupStep(n: "2", t: "Keyboards > Add New Keyboard")
                            SetupStep(n: "3", t: "Select 'Nova Keyboard AI'")
                            SetupStep(n: "4", t: "Enable Full Access")
                        }
                    }
                    
                    // Reset
                    Button {
                        keyboardHeight = 216
                        keyHeight = 42
                        fontSize = 22
                        keySounds = true
                        hapticFeedback = true
                        saveSettings()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset to Defaults")
                        }
                        .font(.caption).foregroundColor(.white.opacity(0.4))
                    }
                    
                    Text("v1.0 \u{2022} Son3ra1n \u{2022} Nova AI")
                        .font(.system(size: 10)).foregroundColor(.white.opacity(0.2))
                        .padding(.bottom, 30)
                }
            }
        }
        .onAppear { loadSettings() }
        .onChange(of: nativeLanguage) { _ in saveSettings() }
        .onChange(of: targetLanguage) { _ in saveSettings() }
        .onChange(of: keyboardLayout) { _ in saveSettings() }
        .onChange(of: keyboardHeight) { _ in saveSettings() }
        .onChange(of: keyHeight) { _ in saveSettings() }
        .onChange(of: fontSize) { _ in saveSettings() }
        .onChange(of: keySounds) { _ in saveSettings() }
        .onChange(of: hapticFeedback) { _ in saveSettings() }
        .onChange(of: apiBaseURL) { _ in saveSettings() }
        .onChange(of: apiModel) { _ in saveSettings() }
        .onChange(of: apiKey) { _ in saveSettings() }
        .onChange(of: actions) { _ in NovaActionStore.save(actions) }
    }
    
    // MARK: - Settings Card
    func settingsCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline).foregroundColor(.white)
            content()
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    // MARK: - Slider Row
    func sliderRow(label: String, value: Binding<Double>, range: ClosedRange<Double>, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label).font(.caption).foregroundColor(.white.opacity(0.6))
                Spacer()
                Text("\(Int(value.wrappedValue))\(unit)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(red: 0, green: 0.8, blue: 0.85))
            }
            Slider(value: value, in: range, step: 1)
                .accentColor(Color(red: 0, green: 0.8, blue: 0.85))
        }
    }
    
    func loadSettings() {
        nativeLanguage = SharedSettings.string(forKey: AppGroupKeys.nativeLanguage) ?? "Turkish"
        targetLanguage = SharedSettings.string(forKey: AppGroupKeys.targetLanguage) ?? "English"
        keyboardLayout = SharedSettings.string(forKey: AppGroupKeys.keyboardLayout) ?? "Turkish"
        keyboardHeight = SharedSettings.double(forKey: AppGroupKeys.keyboardHeight) ?? 216
        keyHeight = SharedSettings.double(forKey: AppGroupKeys.keyHeight) ?? 42
        fontSize = SharedSettings.double(forKey: AppGroupKeys.fontSize) ?? 22
        keySounds = SharedSettings.bool(forKey: AppGroupKeys.keySounds, defaultValue: true)
        hapticFeedback = SharedSettings.bool(forKey: AppGroupKeys.hapticFeedback, defaultValue: true)
        apiBaseURL = SharedSettings.string(forKey: AppGroupKeys.apiBaseURL) ?? ""
        apiModel = SharedSettings.string(forKey: AppGroupKeys.apiModel) ?? ""
        apiKey = SharedSettings.string(forKey: AppGroupKeys.apiKey)
            ?? (SharedSettings.string(forKey: AppGroupKeys.groqApiKey) ?? "")
        actions = NovaActionStore.load()
        
        if keyboardHeight < 180 { keyboardHeight = 216 }
        if keyHeight < 30 { keyHeight = 42 }
        if fontSize < 14 { fontSize = 22 }
        
        // Load shortcuts
        if let jsonStr = SharedSettings.string(forKey: AppGroupKeys.textShortcuts),
           let data = jsonStr.data(using: .utf8),
           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: String] {
            shortcuts = dict
        }
    }
    
    func saveSettings() {
        apiBaseURL = apiBaseURL.trimmingCharacters(in: .whitespacesAndNewlines)
        apiModel = apiModel.trimmingCharacters(in: .whitespacesAndNewlines)
        apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        SharedSettings.save([
            AppGroupKeys.nativeLanguage: nativeLanguage,
            AppGroupKeys.targetLanguage: targetLanguage,
            AppGroupKeys.keyboardLayout: keyboardLayout,
            AppGroupKeys.keyboardHeight: keyboardHeight,
            AppGroupKeys.keyHeight: keyHeight,
            AppGroupKeys.fontSize: fontSize,
            AppGroupKeys.keySounds: keySounds,
            AppGroupKeys.hapticFeedback: hapticFeedback,
            AppGroupKeys.apiBaseURL: apiBaseURL,
            AppGroupKeys.apiModel: apiModel,
            AppGroupKeys.apiKey: apiKey
        ])
    }
    
    func saveShortcuts() {
        if let data = try? JSONSerialization.data(withJSONObject: shortcuts),
           let jsonStr = String(data: data, encoding: .utf8) {
            SharedSettings.save([AppGroupKeys.textShortcuts: jsonStr])
        }
    }
    
    func runTest(isTranslate: Bool) {
        guard !testText.isEmpty else {
            testResult = "Type something to test first"
            return
        }
        guard !apiBaseURL.isEmpty else {
            testResult = "Error: Base URL missing"
            return
        }

        var trimmed = apiBaseURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.lowercased().hasPrefix("http") { trimmed = "https://" + trimmed }
        while trimmed.hasSuffix("/") { trimmed.removeLast() }
        if !trimmed.lowercased().hasSuffix("/chat/completions") {
            trimmed += trimmed.lowercased().hasSuffix("/v1") ? "/chat/completions" : "/v1/chat/completions"
        }
        guard let url = URL(string: trimmed) else {
            testResult = "Error: invalid Base URL"
            return
        }

        testResult = "Testing..."
        testLatency = ""
        let start = Date()

        let prompt = isTranslate
            ? "Translate from \(nativeLanguage) to \(targetLanguage): \(testText). Return ONLY the translation."
            : "Fix spelling in \(nativeLanguage): \(testText). Return ONLY the corrected text."

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        let body: [String: Any] = [
            "model": apiModel.isEmpty ? "gpt-4o-mini" : apiModel,
            "messages": [["role": "user", "content": prompt]],
            "temperature": 0.7,
            "max_tokens": 300
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 20

        URLSession.shared.dataTask(with: request) { data, response, error in
            let diff = Int(Date().timeIntervalSince(start) * 1000)
            DispatchQueue.main.async {
                testLatency = "\(diff) ms latency"
                if error != nil {
                    testResult = "Error: network unreachable"
                    return
                }
                if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                    testResult = "Error: HTTP \(http.statusCode)"
                    return
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let choices = json["choices"] as? [[String: Any]],
                      let message = choices.first?["message"] as? [String: Any],
                      let text = message["content"] as? String else {
                    testResult = "Error: unexpected response"
                    return
                }
                testResult = "OK → " + text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }.resume()
    }

    func getLayoutPreview() -> String {
        switch keyboardLayout {
        case "Turkish":    return "Q W E R T Y U I O P Ğ Ü"
        case "AZERTY":     return "A Z E R T Y U I O P"
        case "QWERTZ":     return "Q W E R T Y Z U I O P"
        case "Spanish":    return "Q W E R T Y U I O P"
        case "Portuguese": return "Q W E R T Y U I O P"
        case "Italian":    return "Q W E R T Y U I O P"
        default:           return "Q W E R T Y U I O P"
        }
    }
}

struct GestureRow: View {
    let icon: String; let color: Color; let title: String; let desc: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundColor(color).frame(width: 24)
            VStack(alignment: .leading) {
                Text(title).font(.caption).bold().foregroundColor(.white)
                Text(desc).font(.caption2).foregroundColor(.white.opacity(0.5))
            }
        }
    }
}

struct SetupStep: View {
    let n: String; let t: String
    var body: some View {
        HStack(spacing: 10) {
            Text(n).font(.caption2).bold().foregroundColor(.black)
                .frame(width: 20, height: 20).background(Circle().fill(.white))
            Text(t).font(.caption).foregroundColor(.white.opacity(0.8))
        }
    }
}
