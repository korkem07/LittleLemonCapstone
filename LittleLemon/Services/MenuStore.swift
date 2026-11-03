import Foundation
import Combine

@MainActor
final class MenuStore: ObservableObject {
    @Published private(set) var items: [MenuItem] = []
    @Published private(set) var isRefreshing = false
    @Published private(set) var isOffline = false

    private static let cacheKey = "littlelemon.cachedMenu"
    private static let endpoint = URL(string:
        "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
    )!

    init() {
        // App has a usable menu immediately, even without internet access.
        if let cached = UserDefaults.standard.data(forKey: Self.cacheKey),
           let decoded = try? JSONDecoder().decode(MenuResponse.self, from: cached),
           !decoded.menu.isEmpty {
            items = decoded.menu
        } else if let localURL = Bundle.main.url(forResource: "menu", withExtension: "json"),
                  let data = try? Data(contentsOf: localURL),
                  let decoded = try? JSONDecoder().decode(MenuResponse.self, from: data) {
            items = decoded.menu
        }
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        do {
            let (data, response) = try await URLSession.shared.data(from: Self.endpoint)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                isOffline = true
                return
            }
            let decoded = try JSONDecoder().decode(MenuResponse.self, from: data)
            guard !decoded.menu.isEmpty else { return }
            items = decoded.menu
            UserDefaults.standard.set(data, forKey: Self.cacheKey)
            isOffline = false
        } catch {
            // Keep using the cached or bundled menu rather than showing an empty screen.
            isOffline = true
        }
    }
}
