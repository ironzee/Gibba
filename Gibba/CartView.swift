//
//  CartView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

//
//  CartView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import SwiftUI

struct CartView: View {
  let items: [CartItem]
  let onUpdateQuantity: (String, Int) -> Void
  let onRemoveItem: (String) -> Void
  let onPlaceOrder: () -> Void

  private var subtotal: Double { items.reduce(0) { $0 + $1.price * Double($1.quantity) } }
  private let deliveryFee: Double = 15
  private var total: Double { subtotal + deliveryFee }

  var body: some View {
    ScrollArea {
      VStack(spacing: 16) {
        // Header
        HStack(spacing: 10) {
          RoundedRectangle(cornerRadius: 12).fill(Color.orange.opacity(0.15))
            .overlay(Image(systemName: "bag.fill").foregroundStyle(.orange))
            .frame(width: 40, height: 40)
          Text("Your Order").font(.system(size: 18, weight: .bold))
          Spacer()
          Text("\(items.count) items").font(.labelSm)
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Color.orange.opacity(0.15), in: Capsule())
            .foregroundStyle(.orange)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppColor.border))
        .padding(.horizontal, 16)

        if items.isEmpty {
          VStack(spacing: 12) {
            Text("🛒").font(.system(size: 56))
            Text("Your cart is empty").font(.system(size: 18, weight: .bold))
            Text("Add some delicious Moroccan dishes to get started!")
              .font(.system(size: 13)).foregroundStyle(.secondary)
          }
          .padding(24)
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
          .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppColor.border))
          .padding(.horizontal, 16)
        } else {
          // Items
          VStack(spacing: 10) {
            ForEach(items) { item in
              HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 16)
                  .fill(LinearGradient(colors: [.orange.opacity(0.35), .red.opacity(0.35)], startPoint: .top, endPoint: .bottom))
                  .frame(width: 64, height: 64)
                  .overlay(Text("🍽️").font(.system(size: 22)))

                VStack(alignment: .leading, spacing: 4) {
                  Text(item.name).font(.system(size: 15, weight: .medium))
                  Text(item.restaurant).font(.system(size: 12)).foregroundStyle(.secondary)
                  HStack {
                    HStack(spacing: 8) {
                      Button {
                        onUpdateQuantity(item.id, max(0, item.quantity - 1))
                      } label: { Image(systemName: "minus") }
                        .buttonStyle(.bordered)
                      Text("\(item.quantity)").font(.system(size: 14, weight: .medium)).frame(minWidth: 24)
                      Button {
                        onUpdateQuantity(item.id, item.quantity + 1)
                      } label: { Image(systemName: "plus") }
                        .buttonStyle(.bordered)
                    }
                    Spacer()
                    Text("\(Int(item.price * Double(item.quantity))) MAD")
                      .font(.system(size: 15, weight: .bold))
                      .foregroundStyle(.orange)
                  }
                }

                Button(role: .destructive) { onRemoveItem(item.id) } label: {
                  Image(systemName: "trash.fill")
                }
                .buttonStyle(.bordered)
              }
              .padding(12)
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
              .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border))
              .padding(.horizontal, 16)
            }
          }

          // Summary
          VStack(spacing: 10) {
            SummaryRow(title: "Subtotal", value: "\(Int(subtotal)) MAD")
            SummaryRow(title: "Delivery fee", value: "\(Int(deliveryFee)) MAD")
            SeparatorView()
            SummaryRow(title: "Total", value: "\(Int(total)) MAD", bold: true, accent: true)
          }
          .padding(16)
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
          .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border))
          .padding(.horizontal, 16)

          // Place order
          VStack(spacing: 8) {
            Button(action: onPlaceOrder) {
              HStack {
                Spacer()
                Text("Place Order")
                Spacer()
                Text("\(Int(total)) MAD").fontWeight(.bold)
              }
              .padding(.vertical, 14)
              .background(
                LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing),
                in: RoundedRectangle(cornerRadius: 16)
              )
              .foregroundStyle(.white)
            }
            .buttonStyle(.plain)

            Text("Estimated delivery: 25–35 minutes 🚚")
              .font(.system(size: 12))
              .foregroundStyle(.secondary)
          }
          .padding(.horizontal, 16)
        }

        Rectangle().fill(Color.clear).frame(height: 24)
      }
      .padding(.top, 16)
    }
  }
}

private struct SummaryRow: View {
  let title: String
  let value: String
  var bold = false
  var accent = false

  var body: some View {
    HStack {
      Text(title).foregroundStyle(.secondary)
      Spacer()
      Text(value)
        .font(bold ? .system(size: 16, weight: .bold) : .body)
        .foregroundStyle(accent ? .orange : .primary)
    }
    .padding(10)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColor.border))
  }
}
