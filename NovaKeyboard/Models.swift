import Foundation
import SwiftUI

enum KeyboardPage {
    case letters
    case numbers
    case symbols
    case emoji
}

enum KeyboardLayouts {
    static let numRow1 = ["1","2","3","4","5","6","7","8","9","0"]
    static let numRow2 = ["-","/",":",";","(",")","₺","&","@","\""]
    static let numRow3 = [".",",","?","!","'"]

    static let symRow1 = ["[","]","{","}","#","%","^","*","+","="]
    static let symRow2 = ["_","\\","|","~","<",">","€","$","¥","•"]
    static let symRow3 = [".",",","?","!","'"]

    static let turkishRow1 = ["Q","W","E","R","T","Y","U","I","O","P","Ğ","Ü"]
    static let turkishRow2 = ["A","S","D","F","G","H","J","K","L","Ş","İ"]
    static let turkishRow3 = ["Z","X","C","V","B","N","M","Ö","Ç"]

    static let englishRow1 = ["Q","W","E","R","T","Y","U","I","O","P"]
    static let englishRow2 = ["A","S","D","F","G","H","J","K","L"]
    static let englishRow3 = ["Z","X","C","V","B","N","M"]

    static let azertyRow1 = ["A","Z","E","R","T","Y","U","I","O","P"]
    static let azertyRow2 = ["Q","S","D","F","G","H","J","K","L","M"]
    static let azertyRow3 = ["W","X","C","V","B","N"]

    static let qwertzRow1 = ["Q","W","E","R","T","Z","U","I","O","P"]
    static let qwertzRow2 = ["A","S","D","F","G","H","J","K","L"]
    static let qwertzRow3 = ["Y","X","C","V","B","N","M"]

    static let spanishRow1 = ["Q","W","E","R","T","Y","U","I","O","P"]
    static let spanishRow2 = ["A","S","D","F","G","H","J","K","L","Ñ"]
    static let spanishRow3 = ["Z","X","C","V","B","N","M"]

    static let portugueseRow1 = ["Q","W","E","R","T","Y","U","I","O","P"]
    static let portugueseRow2 = ["A","S","D","F","G","H","J","K","L","Ç"]
    static let portugueseRow3 = ["Z","X","C","V","B","N","M"]

    static let italianRow1 = ["Q","W","E","R","T","Y","U","I","O","P"]
    static let italianRow2 = ["A","S","D","F","G","H","J","K","L"]
    static let italianRow3 = ["Z","X","C","V","B","N","M"]

    static func rows(for layout: String) -> (row1: [String], row2: [String], row3: [String]) {
        switch layout {
        case "Turkish":    return (turkishRow1, turkishRow2, turkishRow3)
        case "AZERTY":     return (azertyRow1, azertyRow2, azertyRow3)
        case "QWERTZ":     return (qwertzRow1, qwertzRow2, qwertzRow3)
        case "Spanish":    return (spanishRow1, spanishRow2, spanishRow3)
        case "Portuguese": return (portugueseRow1, portugueseRow2, portugueseRow3)
        case "Italian":    return (italianRow1, italianRow2, italianRow3)
        default:           return (englishRow1, englishRow2, englishRow3)
        }
    }
}

enum AlternateCharacters {
    static let map: [String: [String]] = [
        "A": ["À","Á","Â","Ã","Ä","Å","Æ","Ą"],
        "E": ["È","É","Ê","Ë","Ę","Ė","Œ"],
        "I": ["Ì","Í","Î","Ï","İ","\u{0131}"],
        "O": ["Ò","Ó","Ô","Õ","Ö","Ø","Œ"],
        "U": ["Ù","Ú","Û","Ü"],
        "S": ["Ş","Ś","Š","ß"],
        "C": ["Ç","Ć","Č"],
        "G": ["Ğ","Ġ"],
        "N": ["Ñ","Ń"],
        "Y": ["Ý","Ÿ"],
        "Z": ["Ž","Ź","Ż"],
        "L": ["Ł"],
        "D": ["Ð","Ď"],
        "R": ["Ř"],
        "T": ["Ť","Þ"]
    ]
}

enum AITones {
    static let all = ["Professional", "Casual", "Friendly", "Creative"]
}

enum EmojiCatalog {
    static let categoryIcons = ["😀","❤️","👋","🐶","🍕","🚗","⚡"]
    static let data: [[String]] = [
        ["😀","😃","😄","😁","😆","😅","🤣","😂","🙂","🙃","😉","😊","😇","🥰","😍","🤩","😘","😗","😚","😙","😋","😛","😜","🤪","😝","🤑","🤗","🤭","🤫","🤔","🤐","🤨","😐","😑","😶","😏","😒","🙄","😬","😌","😔","😪","🤤","😴","😷","🤒","🤕","🤢","🤮","🤧","🥵","🥶","🥴","😵","🤯","🤠","🥳","😎","🤓","🧐","😕","😟","🙁","😮","😯","😲","😳","🥺","😨","😰","😥","😢","😭","😱","😖","😣","😞","😩","😫","😤","😡","😠","🤬","😈","👿","💀","💩","🤡","👻","👽","👾","🤖","😺","😸","😹","😻","😼","😽","🙀","😿","😾"],
        ["❤️","🧡","💛","💚","💙","💜","🖤","🤍","🤎","💔","❣️","💕","💞","💓","💗","💖","💘","💝","💟","♥️","💑","💏","💍","💐","🌹","🌷","🌺","🌸","🌼","🌻"],
        ["👋","🤚","🖐","✋","🖖","👌","🤏","✌️","🤞","🤟","🤘","🤙","👈","👉","👆","🖕","👇","☝️","👍","👎","✊","👊","🤛","🤜","👏","🙌","👐","🤲","🤝","🙏","✍️","💅","🤳","💪","🦾","🦿","🦵","🦶","👂","👃","👀","👁","👅","👄"],
        ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🙈","🙉","🙊","🐔","🐧","🐦","🐤","🦆","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝","🐛","🦋","🐌","🐞","🐜","🐢","🐍","🦎","🐙","🦑","🦐","🦀","🐡","🐠","🐟","🐬","🐳","🐋","🦈"],
        ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈","🍒","🍑","🥭","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥒","🌶","🌽","🥕","🧄","🧅","🥔","🍠","🥐","🍞","🥖","🧀","🍗","🍖","🥩","🍳","🥞","🧇","🍕","🌭","🍔","🍟","🌮","🌯","🍿","🧂","🍰","🎂","🍩","🍪"],
        ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🚚","🚛","🚜","🏍","🛵","🚲","🛴","✈️","🚀","🛸","🚁","⛵","🚤","🏠","🏢","🏥","🏫","🏰","🗼","🗽","⛪","🕌","🌍","🌎","🌏","🌑","🌕","🌙","⭐","🌟"],
        ["⚡","💥","🔥","✨","🌟","💫","🎉","🎊","🎈","🎆","🎇","✅","❌","❓","❗","⚠️","🔴","🟠","🟡","🟢","🔵","🟣","⚫","⚪","🏁","🚩","🎌","🏳️","🇹🇷","💯","🔔","🎵","🎶","📸","💬","📌","📎","🔑","💡","🚀"]
    ]
}

enum AppGroupKeys {
    static let suiteName = "group.com.soner.NovaAI"

    static let nativeLanguage = "native_language"
    static let targetLanguage = "target_language"
    static let keyboardLayout = "keyboard_layout"
    static let keyboardHeight = "keyboard_height"
    static let keyHeight = "key_height"
    static let fontSize = "font_size"
    static let keySounds = "key_sounds"
    static let hapticFeedback = "haptic_feedback"
    static let groqApiKey = "groq_api_key"
    static let textShortcuts = "text_shortcuts"

    // Generic OpenAI-compatible endpoint (replaces the Groq-only setup).
    static let apiBaseURL = "api_base_url"
    static let apiModel = "api_model"
    static let apiKey = "api_key"
    static let aiActions = "ai_actions"
}

extension Notification.Name {
    static let novaKeyboardDidAppear = Notification.Name("novaKeyboardDidAppear")
}

/// SharedSettings: multi-layer settings bridge that works across
/// host app ↔ keyboard extension, even without proper provisioning
/// (TrollStore, ad-hoc, etc).
///
/// Write path (host app):  saves to ALL layers
/// Read path (extension):  tries each layer until one succeeds
///
/// Layers:
///   1. App Group UserDefaults (suiteName) — standard iOS
///   2. File-based shared container — TrollStore fallback
///   3. Standard UserDefaults — last resort (only works with Full Access)
enum SharedSettings {

    private static let fileName = "nova_shared_settings.plist"

    // MARK: - Write (call from host app)

    static func save(_ dict: [String: Any]) {
        // Layer 1: App Group UserDefaults
        if let suite = UserDefaults(suiteName: AppGroupKeys.suiteName) {
            for (key, value) in dict {
                suite.set(value, forKey: key)
            }
            suite.synchronize()
        }

        // Layer 2: File-based plist in shared container
        if let url = fileURL() {
            let existing = (NSDictionary(contentsOf: url) as? [String: Any]) ?? [:]
            var merged = existing
            for (key, value) in dict {
                merged[key] = value
            }
            (merged as NSDictionary).write(to: url, atomically: true)
        }

        // Layer 3: Standard UserDefaults (keyboard can read with Full Access)
        for (key, value) in dict {
            UserDefaults.standard.set(value, forKey: "nova_\(key)")
        }
        UserDefaults.standard.synchronize()
    }

    // MARK: - Read (call from keyboard extension)

    static func string(forKey key: String) -> String? {
        // Layer 1: App Group UserDefaults
        if let suite = UserDefaults(suiteName: AppGroupKeys.suiteName),
           let val = suite.string(forKey: key), !val.isEmpty {
            return val
        }

        // Layer 2: File-based plist
        if let url = fileURL(),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let val = dict[key] as? String, !val.isEmpty {
            return val
        }

        // Layer 3: Standard UserDefaults (with "nova_" prefix)
        if let val = UserDefaults.standard.string(forKey: "nova_\(key)"), !val.isEmpty {
            return val
        }

        return nil
    }

    static func double(forKey key: String) -> Double? {
        if let suite = UserDefaults(suiteName: AppGroupKeys.suiteName) {
            if suite.object(forKey: key) != nil {
                return suite.double(forKey: key)
            }
        }
        if let url = fileURL(),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let val = dict[key] as? NSNumber {
            return val.doubleValue
        }
        if UserDefaults.standard.object(forKey: "nova_\(key)") != nil {
            return UserDefaults.standard.double(forKey: "nova_\(key)")
        }
        return nil
    }

    static func bool(forKey key: String, defaultValue: Bool = true) -> Bool {
        if let suite = UserDefaults(suiteName: AppGroupKeys.suiteName) {
            if suite.object(forKey: key) != nil {
                return suite.bool(forKey: key)
            }
        }
        if let url = fileURL(),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let val = dict[key] as? Bool {
            return val
        }
        if UserDefaults.standard.object(forKey: "nova_\(key)") != nil {
            return UserDefaults.standard.bool(forKey: "nova_\(key)")
        }
        return defaultValue
    }

    // MARK: - Shared container file URL

    private static func fileURL() -> URL? {
        // Try App Group container first
        if let container = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: AppGroupKeys.suiteName
        ) {
            return container.appendingPathComponent(fileName)
        }
        // Fallback: app's own documents (won't be shared, but at least won't crash)
        return nil
    }
}

// MARK: - Configurable AI actions

/// One button/gesture in the keyboard's AI menu.
/// `prompt` is the template sent to the model. Placeholders are replaced at run time:
///   {{TEXT}}   selected / current input text
///   {{LANG}}   native language chosen in the app
///   {{TARGET}} target language chosen in the app
///   {{TONE}}   tone picked in the keyboard menu
struct NovaAction: Codable, Identifiable, Equatable {
    var id: String
    var title: String
    var prompt: String
    var enabled: Bool

    init(id: String = UUID().uuidString, title: String, prompt: String, enabled: Bool = true) {
        self.id = id
        self.title = title
        self.prompt = prompt
        self.enabled = enabled
    }

    static let defaults: [NovaAction] = [
        NovaAction(
            id: "tone",
            title: "Tone",
            prompt: """
            Rewrite the text in a {{TONE}} tone. Keep the meaning, do not add new facts. Return ONLY the rewritten text.

            {{TEXT}}
            """
        ),
        NovaAction(
            id: "translate",
            title: "Translate",
            prompt: """
            Translate the following text from {{LANG}} to {{TARGET}}. Return ONLY the translation.

            {{TEXT}}
            """
        ),
        NovaAction(
            id: "spell",
            title: "Fix",
            prompt: """
            The text is written in {{LANG}}. Fix spelling and grammar only, do not translate and do not use other languages. Keep the same meaning and tone. Return ONLY the corrected text.

            {{TEXT}}
            """
        ),
        NovaAction(
            id: "reply",
            title: "Reply",
            prompt: """
            Write a short, natural reply to the message below in {{LANG}}. Return ONLY the reply.

            {{TEXT}}
            """
        )
    ]
}

enum NovaActionStore {

    /// Reads the action list written by the host app. Falls back to the built-in set.
    static func load() -> [NovaAction] {
        guard let raw = SharedSettings.string(forKey: AppGroupKeys.aiActions),
              let data = raw.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([NovaAction].self, from: data),
              !decoded.isEmpty else {
            return NovaAction.defaults
        }
        return decoded
    }

    static func loadEnabled() -> [NovaAction] {
        let all = load().filter { $0.enabled }
        return all.isEmpty ? NovaAction.defaults : all
    }

    static func save(_ actions: [NovaAction]) {
        guard let data = try? JSONEncoder().encode(actions),
              let raw = String(data: data, encoding: .utf8) else { return }
        SharedSettings.save([AppGroupKeys.aiActions: raw])
    }

    static func encoded(_ actions: [NovaAction]) -> String {
        guard let data = try? JSONEncoder().encode(actions),
              let raw = String(data: data, encoding: .utf8) else { return "" }
        return raw
    }

    /// Fills the template placeholders.
    static func render(_ action: NovaAction, text: String, language: String, target: String, tone: String) -> String {
        action.prompt
            .replacingOccurrences(of: "{{TEXT}}", with: text)
            .replacingOccurrences(of: "{{LANG}}", with: language)
            .replacingOccurrences(of: "{{TARGET}}", with: target)
            .replacingOccurrences(of: "{{TONE}}", with: tone)
    }
}

// MARK: - System-style palette

/// Colours and metrics that mirror the stock iOS keyboard.
enum NovaStyle {
    static let cornerRadius: CGFloat = 5
    static let keySpacing: CGFloat = 6
    static let rowSpacing: CGFloat = 12
    static let letterSize: CGFloat = 25

    static func background(_ dark: Bool) -> Color {
        dark ? Color(white: 0.117) : Color(red: 0.819, green: 0.827, blue: 0.847)
    }

    static func keyFill(_ dark: Bool) -> Color {
        dark ? Color(white: 0.42) : .white
    }

    static func specialFill(_ dark: Bool) -> Color {
        dark ? Color(white: 0.235) : Color(red: 0.678, green: 0.698, blue: 0.729)
    }

    static func pressed(_ dark: Bool) -> Color {
        dark ? Color(white: 0.62) : Color(white: 0.86)
    }

    static func keyShadow(_ dark: Bool) -> Color {
        dark ? .clear : Color.black.opacity(0.35)
    }
}
