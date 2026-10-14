//
//  User.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import Foundation

public struct UserProfile: Identifiable, Hashable {
  public let id = UUID()
  public var name: String
  public var email: String
  public var memberSince: Date
  public var ordersCount: Int
  public var favoriteRestaurants: Int
  public var reviewsCount: Int
  public var loyaltyPoints: Int
}
