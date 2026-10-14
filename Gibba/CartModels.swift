//
//  CartModels.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import Foundation

public struct CartItem: Identifiable, Hashable {
  public let id: String
  public let name: String
  public let image: String
  public let restaurant: String
  public let price: Double
  public var quantity: Int
}

public final class CartStore: ObservableObject {
  @Published public var items: [CartItem] = []
  public var subtotal: Double { items.reduce(0) { $0 + ($1.price * Double($1.quantity)) } }
  public var deliveryFee: Double { 15 }
  public var total: Double { subtotal + deliveryFee }

  public func add(_ item: CartItem) {
    if let idx = items.firstIndex(where: { $0.id == item.id }) {
      items[idx].quantity += item.quantity
    } else {
      items.append(item)
    }
  }

  public func updateQuantity(id: String, quantity: Int) {
    guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
    items[idx].quantity = max(0, quantity)
    if items[idx].quantity == 0 { items.remove(at: idx) }
  }

  public func remove(id: String) { items.removeAll { $0.id == id } }
  public func clear() { items.removeAll() }
}
