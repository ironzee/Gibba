//
//  SearchViewModel.swift
//  Gibba
//
//  Created by Zulfiqur on 8/23/25.
//

import Foundation
//
//  SearchViewModel.swift
//  Gibba
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {

  // Inputs / state
  @Published var searchQuery: String = ""
  @Published var activeFilters: Set<String> = []
  @Published var selectedCuisine: String = ""
  @Published var showFilters: Bool = false
  @Published var recentSearches: [String] = ["Tajine", "Seafood restaurants", "Vegetarian options", "Fast delivery"]

  // Data
  @Published var restaurants: [Restaurant]

  // Init (inject from AppViewModel; if omitted, fall back to global dataset)
  init(restaurants: [Restaurant] = moroccanRestaurants) {
    self.restaurants = restaurants
  }

  // MARK: – Filter metadata (mirrors TSX)
  struct QuickFilter: Identifiable { let id: String; let label: String; let icon: String }
  let quickFilters: [QuickFilter] = [
    .init(id: "rating",     label: "Rating 4.5+",    icon: "⭐"),
    .init(id: "delivery",   label: "Fast Delivery",  icon: "⚡"),
    .init(id: "offers",     label: "Has Offers",     icon: "🎉"),
    .init(id: "vegetarian", label: "Vegetarian",     icon: "🥬"),
    .init(id: "pricelow",   label: "Budget Friendly",icon: "💰"),
    .init(id: "open",       label: "Open Now",       icon: "🟢")
  ]

  struct Cuisine: Identifiable { let id = UUID(); let name: String; let icon: String; let count: Int }
  let cuisines: [Cuisine] = [
    .init(name: "Traditional Moroccan", icon: "🏺", count: 12),
    .init(name: "Modern Moroccan",      icon: "✨", count: 8),
    .init(name: "Street Food",          icon: "🥙", count: 15),
    .init(name: "Seafood",              icon: "🐟", count: 6),
    .init(name: "Desserts",             icon: "🍯", count: 10),
    .init(name: "Berber",               icon: "🏔️", count: 4),
    .init(name: "Café",                 icon: "☕", count: 7)
  ]

  let trending: [String] = [
    "Chicken Tajine","Couscous Royal","Moroccan Mint Tea","Beef Kefta",
    "Pastilla","Harira Soup","Chermoula Fish","Honey Baklava"
  ]

  // MARK: – Derived outputs

  var isSearching: Bool {
    !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    || !activeFilters.isEmpty
    || !selectedCuisine.isEmpty
  }

  var results: [Restaurant] {
    var filtered = restaurants

    // Text search across name/cuisine/description/specialty/menu
    let q = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    if !q.isEmpty {
      filtered = filtered.filter { r in
        if r.name.lowercased().contains(q) { return true }
        if r.cuisine.lowercased().contains(q) { return true }
        if r.description.lowercased().contains(q) { return true }
        if (r.specialty ?? "").lowercased().contains(q) { return true }
        if r.menu.contains(where: {
          $0.name.lowercased().contains(q)
          || $0.description.lowercased().contains(q)
          || ($0.ingredients ?? []).contains(where: { $0.lowercased().contains(q) })
        }) { return true }
        return false
      }
    }

    // Cuisine filter
    if !selectedCuisine.isEmpty {
      filtered = filtered.filter { $0.cuisine.localizedCaseInsensitiveContains(selectedCuisine) }
    }

    // Quick filters
    if !activeFilters.isEmpty {
      filtered = filtered.filter { r in
        for f in activeFilters {
          switch f {
          case "rating":
            guard r.rating >= 4.5 else { return false }
          case "delivery":
            let mins = Int(r.deliveryTime.split(separator: "-").first?.replacingOccurrences(of: " ", with: "") ?? "") ?? 99
            guard mins <= 25 else { return false }
          case "offers":
            guard (r.offers?.isEmpty == false) else { return false }
          case "vegetarian":
            guard r.menu.contains(where: { $0.isVegetarian == true }) else { return false }
          case "pricelow":
            guard r.priceRange == "$" || r.priceRange == "$$" else { return false }
          case "open":
            guard r.isOpen else { return false }
          default:
            break
          }
        }
        return true
      }
    }

    // Sort by relevance (rating high, delivery time low)
    return filtered.sorted { a, b in
      let aScore = (a.rating * 10) - Double(Int(a.deliveryTime.split(separator: "-").first ?? "99") ?? 99)
      let bScore = (b.rating * 10) - Double(Int(b.deliveryTime.split(separator: "-").first ?? "99") ?? 99)
      return aScore > bScore
    }
  }

  // MARK: – Intents

  func handleSearch(_ query: String) {
    searchQuery = query
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    if !recentSearches.contains(trimmed) {
      recentSearches.insert(trimmed, at: 0)
      if recentSearches.count > 10 { _ = recentSearches.popLast() }
    }
  }

  func toggleFilter(_ id: String) {
    if activeFilters.contains(id) { activeFilters.remove(id) } else { activeFilters.insert(id) }
  }

  func clearAllFilters() {
    activeFilters.removeAll()
    selectedCuisine = ""
    searchQuery = ""
  }

  func clearRecent() { recentSearches.removeAll() }
}
