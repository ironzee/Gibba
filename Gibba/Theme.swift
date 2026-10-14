//
//  Theme.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

// Maps your CSS tokens into SwiftUI colors & radii.
// Tweak to match your OKLCH palette exactly.
enum AppColor {
  static let background = Color.white
  static let foreground = Color.black.opacity(0.9)
  static let card = Color.white
  static let cardForeground = Color.black.opacity(0.9)
  static let primary = Color(white: 0.06) // #030213 approximate
  static let primaryForeground = Color.white
  static let secondary = Color(red: 0.95, green: 0.95, blue: 0.98)
  static let accent = Color(red: 0.91, green: 0.92, blue: 0.94)
  static let destructive = Color(red: 0.83, green: 0.09, blue: 0.24)
  static let border = Color.black.opacity(0.1)
  static let inputBackground = Color(red: 0.95, green: 0.95, blue: 0.96)
    static let ring: Color = Color.gray.opacity(0.5)   // <-- pick any default you like

}

enum AppRadius {
  static let sm: CGFloat = 8
  static let md: CGFloat = 10
  static let lg: CGFloat = 12
  static let xl: CGFloat = 16
  static let pill: CGFloat = 999
}

extension Font {
  static let titleLg = Font.system(size: 22, weight: .semibold)
  static let titleXl = Font.system(size: 28, weight: .bold)
  static let bodyMd = Font.system(size: 16)
  static let labelSm = Font.system(size: 12, weight: .medium)
}
