//
//  OrderTrackingModels.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import Foundation

public struct TrackedOrder: Identifiable {
  public let id: String
  public let itemsCount: Int
  public let total: Double
  public let status: String
  public let estimatedTime: String
  public let restaurant: String
}
