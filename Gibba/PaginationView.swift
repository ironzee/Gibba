//
//  PaginationView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct PaginationView: View {
  public let totalPages: Int
  @Binding public var currentPage: Int
  public var onChange: ((Int) -> Void)?

  public init(totalPages: Int, currentPage: Binding<Int>, onChange: ((Int) -> Void)? = nil) {
    self.totalPages = max(1, totalPages)
    self._currentPage = currentPage
    self.onChange = onChange
  }

  public var body: some View {
    HStack(spacing: 6) {
      Button { move(-1) } label: { Image(systemName: "chevron.left") }
        .appButton(variant: .outline, size: .icon)
        .disabled(currentPage <= 1)

      ForEach(pagesToShow(), id: \.self) { p in
        if p == -1 {
          Text("…").frame(width: 36, height: 36).foregroundStyle(.secondary)
        } else {
          Button {
            currentPage = p; onChange?(p)
          } label: {
            Text("\(p)").font(.system(size: 14, weight: .semibold))
              .frame(width: 36, height: 36)
              .background(p == currentPage ? Color.primary : Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
              .foregroundStyle(p == currentPage ? Color.white : .primary)
          }
          .buttonStyle(.plain)
        }
      }

      Button { move(+1) } label: { Image(systemName: "chevron.right") }
        .appButton(variant: .outline, size: .icon)
        .disabled(currentPage >= totalPages)
    }
  }

  private func move(_ delta: Int) { let p = min(max(1, currentPage + delta), totalPages); currentPage = p; onChange?(p) }

  // Produces compact pagination with ellipses, e.g., 1 … 4 5 [6] 7 8 … 20
  private func pagesToShow() -> [Int] {
    let maxButtons = 7
    if totalPages <= maxButtons { return Array(1...totalPages) }
    var pages: [Int] = []
    let start = max(2, currentPage - 2)
    let end = min(totalPages - 1, currentPage + 2)

    pages.append(1)
    if start > 2 { pages.append(-1) } // ellipsis
    pages.append(contentsOf: start...end)
    if end < totalPages - 1 { pages.append(-1) }
    pages.append(totalPages)
    return pages
  }
}
