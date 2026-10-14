//
//  GlassTopBar.swift
//  Gibba
//
//  Created by Zulfiqur on 8/23/25.
//

import Foundation
//
//  GlassTopBar.swift
//  Gibba
//

import SwiftUI

struct GlassTopBar: View {
  var body: some View {
    HStack {
      Text("Gibba")
        .font(.system(size: 18, weight: .bold))
      Spacer()
      HStack(spacing: 8) {
        Image(systemName: "bell.badge.fill")
        Image(systemName: "ellipsis.circle")
      }
      .font(.system(size: 16, weight: .semibold))
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(.ultraThinMaterial, in: Capsule())
    .overlay(Capsule().stroke(AppColor.border))
    .padding(.horizontal, 16)
    .padding(.top, 10)
  }
}
