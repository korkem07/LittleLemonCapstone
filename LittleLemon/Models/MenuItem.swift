import Foundation

struct MenuItem: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String

    var formattedPrice: String {
        guard let value = Double(price) else { return "$\(price)" }
        return String(format: "$%.2f", value)
    }

    var displayCategory: String {
        switch category.lowercased() {
        case "starters": return "Starters"
        case "mains": return "Mains"
        case "desserts": return "Desserts"
        case "drinks": return "Drinks"
        default: return category.capitalized
        }
    }
}

struct MenuResponse: Codable {
    let menu: [MenuItem]
}

enum MenuFilter {
    static let categories = ["All", "Starters", "Mains", "Desserts", "Drinks"]

    static func apply(to items: [MenuItem], category: String, search: String) -> [MenuItem] {
        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        return items.filter { item in
            let matchesCategory = category == "All" || item.displayCategory == category
            let matchesSearch = trimmed.isEmpty ||
                item.title.localizedCaseInsensitiveContains(trimmed) ||
                item.description.localizedCaseInsensitiveContains(trimmed)
            return matchesCategory && matchesSearch
        }
        .sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
    }
}
