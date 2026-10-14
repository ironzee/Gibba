//
//  NavigationMenuView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//


import SwiftUI

struct NavMenuItem: Identifiable, Hashable {
  let id = UUID()
  var title: String
  var subtitle: String? = nil
  var systemImage: String? = nil
  var destination: Screen? = nil
  var action: (() -> Void)? = nil

  static func == (lhs: NavMenuItem, rhs: NavMenuItem) -> Bool { lhs.id == rhs.id }
  func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct NavigationMenuView<Trigger: View>: View {
  @State private var open = false
  let trigger: Trigger
  let items: [NavMenuItem]

  public init(items: [NavMenuItem], @ViewBuilder trigger: () -> Trigger) {
    self.items = items
    self.trigger = trigger()
  }

  var body: some View {
    Button { open.toggle() } label: { trigger }
      // If your minimum iOS is < 16, remove attachmentAnchor/arrowEdge.
      .popover(isPresented: $open, attachmentAnchor: .rect(.bounds), arrowEdge: .bottom) {
        menuContent
      }
  }

  // Split content so the type checker has an easier time.
  private var menuContent: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        ForEach(items) { item in
          Button {
            item.action?()     // safe optional call
            open = false
          } label: {
            HStack(spacing: 10) {
              if let s = item.systemImage {
                Image(systemName: s).foregroundStyle(.secondary)
              }
              VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                  .font(.system(size: 14, weight: .medium))
                if let sub = item.subtitle, !sub.isEmpty {
                  Text(sub)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                }
              }
              Spacer()
            }
            .padding(10)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.06)))
          }
          .buttonStyle(.plain)
        }
      }
      .padding(12)
    }
    .frame(maxWidth: 340, maxHeight: 420)
    .presentationCompactAdaptation(.popover)
  }
}
