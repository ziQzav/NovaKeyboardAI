import Foundation

/// Talks to any OpenAI-compatible `/chat/completions` endpoint.
/// Base URL, model name and API key all come from the app settings
/// (stored in the shared App Group container), so the keyboard is not
/// tied to one provider anymore.
final class NovaAIEngine {
    static let shared = NovaAIEngine()

    enum AIError: Error {
        case noEndpoint
        case noApiKey
        case networkError
        case unauthorized
        case rateLimited
        case serverError(Int)
        case parseError
    }

    private var configuredBaseURL: String {
        SharedSettings.string(forKey: AppGroupKeys.apiBaseURL)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var configuredModel: String {
        SharedSettings.string(forKey: AppGroupKeys.apiModel)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var configuredKey: String {
        if let key = SharedSettings.string(forKey: AppGroupKeys.apiKey)?
            .trimmingCharacters(in: .whitespacesAndNewlines), !key.isEmpty {
            return key
        }
        // Migration: older builds stored the key under the Groq key name.
        return SharedSettings.string(forKey: AppGroupKeys.groqApiKey)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var currentTask: URLSessionDataTask?

    /// Accepts a bare host, a `/v1` base, or a full `/chat/completions` path.
    static func endpointURL(from base: String) -> URL? {
        var trimmed = base.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        if !trimmed.lowercased().hasPrefix("http") {
            trimmed = "https://" + trimmed
        }
        while trimmed.hasSuffix("/") { trimmed.removeLast() }
        if trimmed.lowercased().hasSuffix("/chat/completions") {
            return URL(string: trimmed)
        }
        if trimmed.lowercased().hasSuffix("/v1") {
            return URL(string: trimmed + "/chat/completions")
        }
        return URL(string: trimmed + "/v1/chat/completions")
    }

    func request(prompt: String, completion: @escaping (Result<String, AIError>) -> Void) {
        currentTask?.cancel()

        guard let url = NovaAIEngine.endpointURL(from: configuredBaseURL) else {
            DispatchQueue.main.async { completion(.failure(.noEndpoint)) }
            return
        }

        let key = configuredKey
        if key.isEmpty && url.host?.contains("groq.com") == true {
            DispatchQueue.main.async { completion(.failure(.noApiKey)) }
            return
        }

        let model = configuredModel.isEmpty ? "llama-3.3-70b-versatile" : configuredModel
        let body: [String: Any] = [
            "model": model,
            "messages": [["role": "user", "content": prompt]],
            "temperature": 0.7,
            "max_tokens": 500
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async { completion(.failure(.parseError)) }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !key.isEmpty {
            request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        request.timeoutInterval = 15

        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error as NSError?, err.domain == NSURLErrorDomain && err.code == NSURLErrorCancelled {
                // Task was cancelled by a newer request, do not return failure
                return
            }

            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(.failure(.networkError)) }
                return
            }

            if let http = response as? HTTPURLResponse {
                switch http.statusCode {
                case 200: break
                case 401, 403:
                    DispatchQueue.main.async { completion(.failure(.unauthorized)) }
                    return
                case 429:
                    DispatchQueue.main.async { completion(.failure(.rateLimited)) }
                    return
                case 400...499, 500...599:
                    DispatchQueue.main.async { completion(.failure(.serverError(http.statusCode))) }
                    return
                default: break
                }
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let text = message["content"] as? String {
                let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
                DispatchQueue.main.async { completion(.success(cleaned)) }
                return
            }

            // Some OpenAI-compatible servers answer with a bare error object.
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = (json["error"] as? [String: Any])?["message"] as? String {
                DispatchQueue.main.async { completion(.failure(.serverError(message.isEmpty ? 500 : 400))) }
                return
            }

            DispatchQueue.main.async { completion(.failure(.parseError)) }
        }
        currentTask?.resume()
    }
}
