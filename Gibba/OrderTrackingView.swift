//
//  OrderTrackingView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import SwiftUI

struct OrderTrackingView: View {
  let order: Order
  let onBack: () -> Void

  @State private var step: Int = 0
  @State private var progress: Double = 15

  // (label, description, sf-symbol)
  private let steps: [(String, String, String)] = [
    ("Order Confirmed", "Your order has been confirmed", "checkmark.circle"),
    ("Preparing", "The restaurant is preparing your food", "clock"),
    ("Ready for Pickup", "Your order is ready for delivery", "checkmark.circle"),
    ("Picked up", "Driver has picked up your order", "box.truck"),
    ("On the way", "Your order is on the way", "box.truck.badge.clock"),
    ("Delivered", "Enjoy your meal!", "checkmark.seal")
  ]

  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        header
        statusCard
        stepsList
        liveTracking
        driverSection
        orderDetails
        Rectangle().fill(Color.clear).frame(height: 24)
      }
      .padding(.vertical, 12)
    }
  }

  // MARK: - Pieces

  private var header: some View {
    HStack {
      Button(action: onBack) {
        Image(systemName: "chevron.left")
          .padding(10)
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
          .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
      }
      .buttonStyle(.plain)

      Text("Track Order #\(order.id)")
        .font(.system(size: 18, weight: .bold))
      Spacer()
    }
    .padding(.horizontal, 16)
  }

  private var statusCard: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(steps[clampedStep].0)
        .font(.system(size: 18, weight: .bold))
      Text(steps[clampedStep].1)
        .foregroundStyle(.secondary)

      AppProgressView(value: $progress, height: 10)
        .onAppear {
          // advance progress every 3s until delivered
          Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { t in
            guard step < steps.count - 1 else { t.invalidate(); return }
            step += 1
            progress = (Double(step + 1) / Double(steps.count)) * 100.0
          }
        }

      HStack(spacing: 6) {
        Image(systemName: "clock")
        Text("Estimated delivery: \(order.estimatedTime)")
          .font(.system(size: 13))
      }
      .foregroundStyle(.secondary)
    }
    .padding(16)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColor.border))
    .padding(.horizontal, 16)
  }

  private var stepsList: some View {
    VStack(spacing: 10) {
      ForEach(steps.indices, id: \.self) { i in
        StepRow(
          title: steps[i].0,
          subtitle: steps[i].1,
          systemImage: steps[i].2,
          isCurrent: i == step,
          isCompleted: i <= step
        )
        .padding(.horizontal, 16)
      }
    }
  }

  private var liveTracking: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Live Tracking").font(.system(size: 16, weight: .bold))
      MiniAnimatedMap(currentStep: step)
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.border))
    }
    .padding(.horizontal, 16)
    .padding(.top, 4)
  }

  private var driverSection: some View {
    Group {
      if step >= 3 {
        DriverCard()
          .padding(.horizontal, 16)
      }
    }
  }

  private var orderDetails: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Order Details").font(.system(size: 16, weight: .bold))

      DetailRow(title: "Restaurant", value: order.restaurant)
      DetailRow(title: "Items", value: "\(order.items.count) items")
      DetailRow(title: "Total", value: "\(Int(order.total)) MAD", accent: true)

      SeparatorView()

      HStack(spacing: 8) {
        Image(systemName: "mappin.and.ellipse").foregroundStyle(.secondary)
        Text("Delivering to: Gueliz, Marrakech")
          .font(.system(size: 13))
      }
      .padding(10)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
      .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
    }
    .padding(16)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColor.border))
    .padding(.horizontal, 16)
  }

  private var clampedStep: Int { min(max(step, 0), steps.count - 1) }
}

// MARK: - Small Views

private struct StepRow: View {
  let title: String
  let subtitle: String
  let systemImage: String
  let isCurrent: Bool
  let isCompleted: Bool

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: systemImage)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(isCompleted ? .green : .secondary)
        .padding(10)
        .background(
          (isCompleted ? Color.green.opacity(0.12) : Color.white.opacity(0.2)),
          in: RoundedRectangle(cornerRadius: 12)
        )
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.system(size: 15, weight: .semibold))
          .foregroundStyle(isCompleted ? .primary : .secondary)
        Text(subtitle)
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }

      Spacer()

      if isCompleted {
        Image(systemName: "checkmark.circle.fill")
          .foregroundStyle(.green)
      }
    }
    .padding(12)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .fill(isCurrent
              ? Color.orange.opacity(0.15)
              : (isCompleted ? Color.green.opacity(0.12) : Color.clear))
    )
  }
}

// MARK: - Other helpers (unchanged)

private struct DetailRow: View {
  let title: String
  let value: String
  var accent: Bool = false
  var body: some View {
    HStack {
      Text(title).foregroundStyle(.secondary)
      Spacer()
      Text(value)
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(accent ? .orange : .primary)
    }
    .padding(10)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
  }
}

private struct DriverCard: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Your Delivery Driver").font(.system(size: 16, weight: .bold))

      HStack(spacing: 12) {
        RoundedRectangle(cornerRadius: 12)
          .fill(LinearGradient(colors: [.blue.opacity(0.35), .indigo.opacity(0.35)],
                               startPoint: .top, endPoint: .bottom))
          .frame(width: 56, height: 56)
          .overlay(Text("👨‍🦱").font(.system(size: 26)))

        VStack(alignment: .leading, spacing: 4) {
          Text("Ahmed El Fassi").font(.system(size: 15, weight: .semibold))
          Text("Blue Yamaha Scooter").font(.system(size: 12)).foregroundStyle(.secondary)
          HStack(spacing: 4) {
            Image(systemName: "star.fill").foregroundStyle(.yellow)
            Text("4.9").font(.system(size: 12)).foregroundStyle(.secondary)
          }
        }

        Spacer()

        Button { } label: {
          Image(systemName: "phone.fill")
            .padding(10)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
        }
        .buttonStyle(.plain)
      }
    }
    .padding(16)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColor.border))
  }
}

private struct MiniAnimatedMap: View {
  let currentStep: Int
  @State private var x: CGFloat = 0.2
  @State private var y: CGFloat = 0.6

  var body: some View {
    GeometryReader { geo in
      ZStack {
        LinearGradient(colors: [.green.opacity(0.12), .blue.opacity(0.12)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)

        Path { p in
          let w = geo.size.width, h = geo.size.height
          let start = CGPoint(x: 0.2*w, y: 0.6*h)
          let end   = CGPoint(x: 0.8*w, y: 0.4*h)
          let ctrl  = CGPoint(x: 0.5*w, y: 0.3*h)
          p.move(to: start)
          p.addQuadCurve(to: end, control: ctrl)
        }
        .stroke(Color.gray.opacity(0.45), style: StrokeStyle(lineWidth: 3, dash: [8,4]))

        Circle().fill(Color.orange.opacity(0.9)).frame(width: 18, height: 18)
          .overlay(Text("🏪").font(.system(size: 11)))
          .position(x: 0.2*geo.size.width, y: 0.6*geo.size.height)

        Circle().fill(Color.green.opacity(0.9)).frame(width: 18, height: 18)
          .overlay(Text("🏠").font(.system(size: 11)))
          .position(x: 0.8*geo.size.width, y: 0.4*geo.size.height)

        if currentStep >= 3 {
          Circle().fill(Color.blue.opacity(0.9)).frame(width: 18, height: 18)
            .overlay(Text("🏍️").font(.system(size: 11)))
            .position(x: x*geo.size.width, y: y*geo.size.height)
            .onAppear {
              withAnimation(.linear(duration: 0.2).repeatForever(autoreverses: false)) {
                y = 0.5 + (CGFloat.random(in: -0.05...0.05))
              }
              Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { t in
                guard x < 0.8 else { t.invalidate(); return }
                x += 0.02
              }
            }
        }
      }
      .background(.ultraThinMaterial)
    }
  }
}

private extension Array {
  subscript(safe index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
