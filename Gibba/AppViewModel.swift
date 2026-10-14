//
//  AppViewModel.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

//
//  AppViewModel.swift
//  Gibba
//

import Foundation
import SwiftUI

final class AppViewModel: ObservableObject {
  // Tabs
  @Published var selectedTab: AppTab = .home

  // Data
  @Published var restaurants: [Restaurant] = moroccanRestaurants
  @Published var cart: [CartItem] = []
  @Published var currentOrder: Order? = nil

  // Sheets / overlays (detail flows)
  @Published var presentedRestaurant: Restaurant? = nil
  @Published var presentedTracking: Order? = nil

  // Cart helpers
  func addToCart(item: MenuItem, from restaurant: Restaurant) {
    if let idx = cart.firstIndex(where: { $0.id == item.id }) {
      cart[idx].quantity += 1
    } else {
      cart.append(.init(
        id: item.id,
        name: item.name,
        image: item.image,
        restaurant: restaurant.name,
        price: item.price,
        quantity: 1
      ))
    }
  }

  func updateQuantity(for id: String, quantity: Int) {
    guard let idx = cart.firstIndex(where: { $0.id == id }) else { return }
    if quantity <= 0 { cart.remove(at: idx) } else { cart[idx].quantity = quantity }
  }

  func removeFromCart(id: String) {
    cart.removeAll { $0.id == id }
  }

    func placeOrder() {
      // compute subtotal from cart
      let subtotal = cart.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
      let deliveryFee = 15.0
      let total = subtotal + deliveryFee

      // pick a representative restaurant name if you need to show it
      let restaurantName = cart.first?.restaurant ?? "Multiple Restaurants"

      currentOrder = .init(
        id: UUID().uuidString,
        items: cart,
        total: total,                         // ⬅️ required by your Order
        estimatedTime: "25–35 min",           // ⬅️ required by your Order
        restaurant: restaurantName            // ⬅️ required by your Order
      )

      cart.removeAll()
      presentedTracking = currentOrder
    }

}
