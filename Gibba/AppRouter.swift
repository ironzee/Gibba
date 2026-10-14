//
//  AppRouter.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//
import SwiftUI

import SwiftUI

enum Screen: Hashable {
  case home
  case restaurant(Restaurant)
  case cart
  case profile
  case tracking(Order)
}
