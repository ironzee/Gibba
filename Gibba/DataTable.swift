//
//  DataTable.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct TableColumnDescriptor<Row>: Identifiable {
  public let id = UUID()
  public let title: String
  public let keyPath: KeyPath<Row, String>?
  public let width: CGFloat?
  public let alignment: Alignment
  public let content: ((Row) -> AnyView)?

  public init(_ title: String,
              keyPath: KeyPath<Row, String>? = nil,
              width: CGFloat? = nil,
              alignment: Alignment = .leading,
              content: ((Row) -> AnyView)? = nil) {
    self.title = title
    self.keyPath = keyPath
    self.width = width
    self.alignment = alignment
    self.content = content
  }
}

public struct DataTable<Row: Identifiable>: View {
  public enum SortOrder { case none, asc, desc }

  @State private var sortKey: UUID? = nil
  @State private var order: SortOrder = .none

  let rows: [Row]
  let columns: [TableColumnDescriptor<Row>]

  public init(rows: [Row], columns: [TableColumnDescriptor<Row>]) {
    self.rows = rows; self.columns = columns
  }

  public var body: some View {
    VStack(spacing: 0) {
      // Header
      HStack(spacing: 0) {
        ForEach(columns) { col in
          Button {
            if sortKey == col.id {
              order = order == .asc ? .desc : (order == .desc ? .none : .asc)
            } else { sortKey = col.id; order = .asc }
          } label: {
            HStack(spacing: 6) {
              Text(col.title).font(.system(size: 12, weight: .semibold))
              if sortKey == col.id {
                Image(systemName: order == .asc ? "chevron.up" : (order == .desc ? "chevron.down" : "chevron.up.chevron.down"))
                  .font(.system(size: 10, weight: .bold))
                  .foregroundStyle(.secondary)
              }
            }
            .frame(maxWidth: .infinity, alignment: map(col.alignment))
            .padding(.vertical, 10).padding(.horizontal, 12)
            .background(Color(.secondarySystemBackground))
          }
          .buttonStyle(.plain)
          .frame(width: col.width)
          Divider().frame(height: 1).opacity(0) // keeps sizes consistent
        }
      }
      .overlay(Rectangle().fill(Color.black.opacity(0.06)).frame(height: 1), alignment: .bottom)

      // Rows
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(sortedRows(), id: \.id) { row in
            HStack(spacing: 0) {
              ForEach(columns) { col in
                let cell: AnyView = {
                  if let c = col.content { return c(row) }
                  if let kp = col.keyPath { return AnyView(Text(row[keyPath: kp])) }
                  return AnyView(EmptyView())
                }()
                cell
                  .frame(maxWidth: .infinity, alignment: col.alignment)
                  .padding(.vertical, 10).padding(.horizontal, 12)
                  .frame(width: col.width, alignment: col.alignment)
                  .background(Color.clear)
              }
            }
            .background(
              Rectangle().fill(Color.clear)
                .overlay(Rectangle().fill(Color.black.opacity(0.04)).frame(height: 1), alignment: .bottom)
            )
          }
        }
      }
    }
    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.06)))
  }

  private func sortedRows() -> [Row] {
    guard let key = sortKey, let col = columns.first(where: { $0.id == key }), let kp = col.keyPath else { return rows }
    switch order {
      case .none: return rows
      case .asc:  return rows.sorted { $0[keyPath: kp].localizedCaseInsensitiveCompare($1[keyPath: kp]) == .orderedAscending }
      case .desc: return rows.sorted { $0[keyPath: kp].localizedCaseInsensitiveCompare($1[keyPath: kp]) == .orderedDescending }
    }
  }

  private func map(_ alignment: Alignment) -> Alignment {
    alignment
  }
}
