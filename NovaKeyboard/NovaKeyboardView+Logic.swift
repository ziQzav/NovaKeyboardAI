import SwiftUI
import UIKit
import AudioToolbox
import os.signpost

// Signpost logger for Instruments — subsystem matches embedding target bundle ID
fileprivate let aiLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.soner.NovaAI", category: "AI")

extension NovaKeyboardView {

    func playKeySound() {
        if keySoundsEnabled { AudioServicesPlaySystemSound(1104) }
        // Note: haptic is now fired by individual key views on touchUp, not here
    }

    func requestFullAccess() {
        statusMessage = "⚠️ Full Access required → Opening Settings..."
        if let kvc = controller as? KeyboardViewController {
            kvc.openAppSettings()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.statusMessage = "Nova AI Ready" }
    }

    func updateAutoCapitalize() {
        if engine.shouldAutoCapitalize() {
            shouldAutoCapitalize = true
            if !isCapsLocked { isShifted = true }
        }
    }

    /// Runs one configured action against the text currently in the input field.
    func runAction(_ action: NovaAction, tone: String? = nil) {
        guard !isProcessing else { return }
        guard controller.hasFullAccess else {
            requestFullAccess()
            return
        }
        let text = engine.contextBeforeInput
        guard !text.isEmpty else {
            statusMessage = "Type something first"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.statusMessage = "Nova AI Ready" }
            return
        }

        let lang = SharedSettings.string(forKey: AppGroupKeys.nativeLanguage) ?? "Turkish"
        let target = SharedSettings.string(forKey: AppGroupKeys.targetLanguage) ?? "English"
        let prompt = NovaActionStore.render(
            action,
            text: text,
            language: lang,
            target: target,
            tone: tone ?? selectedTone
        )

        isProcessing = true
        statusMessage = "\(action.title)..."

        let signpostID = OSSignpostID(log: aiLog)
        os_signpost(.begin, log: aiLog, name: "ActionRequest", signpostID: signpostID)
        NovaAIEngine.shared.request(prompt: prompt) { result in
            os_signpost(.end, log: aiLog, name: "ActionRequest", signpostID: signpostID)
            self.applyResult(result, originalText: text)
        }
    }

    /// Looks up an action by id from the user's configuration, falling back to the built-in one.
    func configuredAction(id: String) -> NovaAction? {
        if let match = NovaActionStore.load().first(where: { $0.id == id }) { return match }
        return NovaAction.defaults.first(where: { $0.id == id })
    }

    func rewriteText(tone: String) {
        guard let action = configuredAction(id: "tone") else { return }
        runAction(action, tone: tone)
    }

    func translateText(_ text: String) {
        guard let action = configuredAction(id: "translate") else { return }
        runAction(action)
    }

    func spellCheckText(_ text: String) {
        guard let action = configuredAction(id: "spell") else { return }
        runAction(action)
    }

    func applyResult(_ result: Result<String, NovaAIEngine.AIError>, originalText: String) {
        isProcessing = false
        switch result {
        case .success(let newText):
            let replaceResult = engine.safeReplace(originalText: originalText, with: newText)
            statusMessage = replaceResult.reason
            if replaceResult.success {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        case .failure(let error):
            switch error {
            case .noApiKey:
                statusMessage = controller.hasFullAccess
                    ? "API key missing — save in Nova app"
                    : "Full Access disabled — API key unavailable"
            case .networkError:       statusMessage = "Network error"
            case .unauthorized:       statusMessage = "Invalid API Key"
            case .rateLimited:        statusMessage = "Rate limited. Wait a moment."
            case .serverError(let c): statusMessage = "Server error (\(c))"
            case .parseError:         statusMessage = "Error. Try again."
            case .noEndpoint:         statusMessage = "No API URL — set it in Nova app"
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { self.statusMessage = "Nova AI Ready" }
    }

    func checkClipboard() {
        if let text = UIPasteboard.general.string, !text.isEmpty, text.count > 2 {
            clipboardContent = String(text.prefix(25))
        } else {
            clipboardContent = nil
        }
    }

    func loadCachedSettings() {
        let h = SharedSettings.double(forKey: AppGroupKeys.keyHeight) ?? 42
        customKeyHeight = h >= 30 ? CGFloat(h) : 42
        let f = SharedSettings.double(forKey: AppGroupKeys.fontSize) ?? 22
        customFontSize = f >= 14 ? CGFloat(f) : 22
        keySoundsEnabled = SharedSettings.bool(forKey: AppGroupKeys.keySounds)
        hapticEnabled = SharedSettings.bool(forKey: AppGroupKeys.hapticFeedback)
        keyboardLayout = SharedSettings.string(forKey: AppGroupKeys.keyboardLayout) ?? "Turkish"

        let rows = KeyboardLayouts.rows(for: keyboardLayout)
        cachedRow1 = rows.row1
        cachedRow2 = rows.row2
        cachedRow3 = rows.row3
    }

    func loadShortcuts() {
        guard let jsonStr = SharedSettings.string(forKey: AppGroupKeys.textShortcuts),
              let data = jsonStr.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: String] else { return }
        cachedShortcuts = dict
    }

    func checkShortcuts() {
        if engine.checkAndApplyShortcut(shortcuts: cachedShortcuts) {
            playKeySound()
        }
    }
}
