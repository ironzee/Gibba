//
//  SidebarView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct SidebarItem: Identifiable, Hashable {
  public let id = UUID()
  public let title: String
  public let systemImage: String
  public let badge: String?
  public init(_ title: String, systemImage: String, badge: String? = nil) {
    self.title = title; self.systemImage = systemImage; self.badge = badge
  }
}

public struct SidebarSection: Identifiable, Hashable {
  public let id = UUID()
  public let header: String?
  public let items: [SidebarItem]
  public init(header: String? = nil, items: [SidebarItem]) {
    self.header = header; self.items = items
  }
}

public struct SidebarView: View {
  @Binding var selection: SidebarItem?
  let sections: [SidebarSection]
  public var isCollapsed: Bool = false
  public var width: CGFloat = 260
  public var collapsedWidth: CGFloat = 68
  public var onItemTap: ((SidebarItem) -> Void)?

  public init(selection: Binding<SidebarItem?>,
              sections: [SidebarSection],
              isCollapsed: Bool = false,
              width: CGFloat = 260,
              collapsedWidth: CGFloat = 68,
              onItemTap: ((SidebarItem) -> Void)? = nil) {
    self._selection = selection
    self.sections = sections
    self.isCollapsed = isCollapsed
    self.width = width
    self.collapsedWidth = collapsedWidth
    self.onItemTap = onItemTap
  }

  public var body: some View {
    VStack(spacing: 8) {
      ForEach(sections) { section in
        if let title = section.header, !isCollapsed {
          Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.top, 10)
        }
        ForEach(section.items) { item in
          Button {
            selection = item
            onItemTap?(item)
          } label: {
            HStack(spacing: 12) {
              Image(systemName: item.systemImage)
                .frame(width: 20)
              if !isCollapsed {
                Text(item.title)
                  .lineLimit(1)
                Spacer()
                if let b = item.badge {
                  Text(b)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Color.blue.opacity(0.12), in: Capsule())
                    .foregroundStyle(.blue)
                }
              }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
              (selection == item ? Color.primary.opacity(0.12) : Color(.secondarySystemBackground)),
              in: RoundedRectangle(cornerRadius: 10)
            )
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(selection == item ? Color.primary.opacity(0.25) : Color.black.opacity(0.06))
            )
          }
          .buttonStyle(.plain)
          .contentShape(Rectangle())
          .padding(.horizontal, 8)
        }
      }
      Spacer(minLength: 0)
    }
    .padding(.top, 12)
    .frame(width: isCollapsed ? collapsedWidth : width)
    .background(.ultraThinMaterial)
  }
}
