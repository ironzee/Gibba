//
//  CommandPalette.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//
//
//  CommandPalette.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import SwiftUI

struct CommandItem: Identifiable, Hashable {
  let id: UUID = UUID()
  var title: String
  var subtitle: String?
  var systemImage: String?
  var action: (() -> Void)?

  static func == (lhs: CommandItem, rhs: CommandItem) -> Bool { lhs.id == rhs.id }
  func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct CommandSection: Identifiable {
  let id = UUID()
  let title: String?
  let items: [CommandItem]
  init(title: String? = nil, items: [CommandItem]) {
    self.title = title
    self.items = items
  }
}

final class CommandViewModel: ObservableObject {
  @Published var query: String = ""
  @Published var isPresented: Bool = false
  @Published var sections: [CommandSection] = []

  var filtered: [CommandSection] {
    guard !query.isEmpty else { return sections }
    let q = query.lowercased()
    return sections
      .map { s in
        let items = s.items.filter {
          $0.title.lowercased().contains(q) ||
          ($0.subtitle?.lowercased().contains(q) ?? false)
        }
        return CommandSection(title: s.title, items: items)
      }
      .filter { !$0.items.isEmpty }
  }
}

struct CommandPalette: View {
  @ObservedObject var vm: CommandViewModel
  init(vm: CommandViewModel) { self.vm = vm }

  var body: some View {
    ZStack {
      if vm.isPresented {
        Color.black.opacity(0.45)
          .ignoresSafeArea()
          .transition(.opacity)

        VStack(spacing: 0) {
          // Search field
          HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
              .foregroundStyle(.secondary)
            TextField("Type a command…", text: $vm.query)
              .textInputAutocapitalization(.never)
              .disableAutocorrection(true)
          }
          .padding(12)
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
          .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.08)))
          .padding(.horizontal, 12)
          .padding(.top, 12)

          // Results
          ScrollView {
            VStack(spacing: 8) {
              ForEach(vm.filtered) { section in
                if let title = section.title, !title.isEmpty {
                  Text(title.uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }

                ForEach(section.items) { item in
                  Button {
                    item.action?()
                    vm.isPresented = false
                  } label: {
                    HStack(spacing: 12) {
                      Image(systemName: item.systemImage ?? "circle")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)

                      VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                          .foregroundStyle(.primary)
                        if let sub = item.subtitle {
                          Text(sub)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        }
                      }
                      Spacer()
                    }
                    .padding(12)
                    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.06)))
                  }
                  .buttonStyle(.plain)
                }
              }
            }
            .padding(12)
          }
          .frame(maxHeight: 360)
        }
        .frame(maxWidth: 560)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08)))
        .padding(20)
        .transition(.scale.combined(with: .opacity))
      }
    }
    .animation(.easeInOut(duration: 0.18), value: vm.isPresented)
  }
}
