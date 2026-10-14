//
//  LabelView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct LabelView: View {
  let text: String
  public var required: Bool = false
  public var helpText: String? = nil
  public init(_ text: String, required: Bool = false, helpText: String? = nil) {
    self.text = text; self.required = required; self.helpText = helpText
  }
  public var body: some View {
    HStack(spacing: 6) {
      Text(text).font(.system(size: 14, weight: .medium))
      if required { Text("*").foregroundStyle(.red).font(.system(size: 14, weight: .semibold)) }
      if let help = helpText {
        Text(help).font(.system(size: 12)).foregroundStyle(.secondary)
      }
    }
  }
}
