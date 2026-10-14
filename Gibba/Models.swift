//
//  Models.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import Foundation

// Models.swift (or wherever your types live)

import Foundation

public struct MenuItem: Identifiable, Hashable {
  public let id: String
  public let name: String
  public let description: String
  public let price: Double
  public let image: String
  public let category: String
  public var isVegetarian: Bool
  public var isSpicy: Bool
  public var isPopular: Bool
  public var ingredients: [String]
  public var calories: Int?

  public init(
    id: String,
    name: String,
    description: String,
    price: Double,
    image: String = "",
    category: String,
    isVegetarian: Bool = false,
    isSpicy: Bool = false,
    isPopular: Bool = false,
    ingredients: [String] = [],
    calories: Int? = nil
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.price = price
    self.image = image
    self.category = category
    self.isVegetarian = isVegetarian
    self.isSpicy = isSpicy
    self.isPopular = isPopular
    self.ingredients = ingredients
    self.calories = calories
  }
}

public struct Restaurant: Identifiable, Hashable {
  public let id: String
  public let name: String
  public let image: String
  public let rating: Double
  public let deliveryTime: String
  public let deliveryFee: Double
  public let cuisine: String
  public let description: String
  public let menu: [MenuItem]
  public let isOpen: Bool
  public let distance: String
  public let offers: [String]?
  public let specialty: String?
  public let priceRange: String

  public init(
    id: String,
    name: String,
    image: String = "",
    rating: Double,
    deliveryTime: String,
    deliveryFee: Double,
    cuisine: String,
    description: String,
    menu: [MenuItem],
    isOpen: Bool,
    distance: String,
    offers: [String]? = nil,
    specialty: String? = nil,
    priceRange: String
  ) {
    self.id = id
    self.name = name
    self.image = image
    self.rating = rating
    self.deliveryTime = deliveryTime
    self.deliveryFee = deliveryFee
    self.cuisine = cuisine
    self.description = description
    self.menu = menu
    self.isOpen = isOpen
    self.distance = distance
    self.offers = offers
    self.specialty = specialty
    self.priceRange = priceRange
  }
}


struct Order: Identifiable, Hashable {
  let id: String
  let items: [CartItem]
  let total: Double
  let estimatedTime: String
  let restaurant: String
}
