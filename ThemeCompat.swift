//
//  ThemeCompat.swift
//  Gibba
//
//  Created by Zulfiqur on 8/23/25.
//

import Foundation
import SwiftUI

import SwiftUI

/// Compatibility layer for older components that expect `Theme.*` tokens.
/// Maps to your `AppColor` / `AppRadius` (if present) and otherwise falls back
/// to sensible SwiftUI defaults.
enum Theme {

  // MARK: - Base colors (aliases to your design tokens)
  static let background: Color = (AppColor.background)
  static let card: Color       = (AppColor.card)
  static let primary: Color    = (AppColor.primary)
  static let secondary: Color  = (AppColor.secondary)
  static let ring: Color       = (AppColor.ring)
  static let border: Color     = (AppColor.border)

  // Common glass presets used around the app
  static let glassFill: Color   = Color.white.opacity(0.20)
  static let glassStroke: Color = Theme.border
  static let destructive: Color = .red
  static let success: Color     = .green
  static let warning: Color     = .orange

  // MARK: - Font sizes used by older views
  enum FontSize {
    static let xs: CGFloat   = 11
    static let sm: CGFloat   = 13
    static let base: CGFloat = 15
    static let lg: CGFloat   = 17
    static let xl: CGFloat   = 20
  }

  // MARK: - Corner radii
  enum Radius {
    static let sm: CGFloat = AppRadius.sm
    static let md: CGFloat = AppRadius.md
    static let lg: CGFloat = AppRadius.lg
    static let xl: CGFloat = AppRadius.xl
  }

  // MARK: - Shadow tokens that some files referenced
  enum Shadow {
    struct Spec { let color: Color; let radius: CGFloat; let x: CGFloat; let y: CGFloat }
    static let card  = Spec(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
    static let dialog = Spec(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 12)
  }

  // MARK: - Color tokens used by older components
  enum ColorToken {
    // surfaces
    static let background: Color = Theme.background
    static let card: Color       = Theme.card
    static let border: Color     = Theme.border

    // brand / status fills
    static let primary: Color    = Theme.primary
    static let secondary: Color  = Theme.secondary
    static let destructive: Color = Theme.destructive
    static let accent: Color      = Theme.primary   // alias for simplicity

    // text colors
    static let foreground: Color            = .primary
    static let primaryForeground: Color     = .white
    static let secondaryForeground: Color   = .primary
    static let destructiveForeground: Color = .white
    static let accentForeground: Color      = Theme.primary
    static let mutedForeground: Color       = .secondary
  }
}
