//
//  GlassAlertDialog.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct GlassAlertDialog: View {
  let title: String
  let message: String
  let primaryTitle: String
  let onPrimary: () -> Void
  let secondaryTitle: String?
  let onSecondary: (() -> Void)?

  public init(
    title: String,
    message: String,
    primaryTitle: String,
    onPrimary: @escaping () -> Void,
    secondaryTitle: String? = nil,
    onSecondary: (() -> Void)? = nil
  ) {
    self.title = title
    self.message = message
    self.primaryTitle = primaryTitle
    self.onPrimary = onPrimary
    self.secondaryTitle = secondaryTitle
    self.onSecondary = onSecondary
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title).font(.system(size: Theme.FontSize.lg, weight: .semibold))
      Text(message).font(.system(size: Theme.FontSize.base)).foregroundStyle(Theme.ColorToken.mutedForeground)

      HStack {
        if let secondaryTitle, let onSecondary {
          Button(secondaryTitle, action: onSecondary)
            .buttonStyle(GlassButtonStyle(variant: .outline))
        }
        Button(primaryTitle, action: onPrimary)
          .buttonStyle(GlassButtonStyle(variant: .default))
      }
      .padding(.top, 4)
    }
  }
}
