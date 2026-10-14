//
//  CapsuleInfo.swift
//  Gibba
//
//  Created by Zulfiqur on 8/23/25.
//

import Foundation
//
//  CapsuleInfo.swift
//  Gibba
//
//  Created by Zulfiqur on 8/23/25.
//

import SwiftUI

struct CapsuleInfo: View {
  let text: String
  let icon: String

  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: icon)
        .font(.system(size: 12))
        .foregroundStyle(.secondary)
      Text(text)
        .font(.system(size: 12, weight: .medium))
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 6)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColor.border))
  }
}

