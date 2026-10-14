//
//  ChartKit.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI
import Charts

// Mirrors the idea of a ChartContainer + Tooltip/Legend config.
// Provide a config dictionary of keys -> label/icon if you want.

public struct ChartConfigItem {
  public let label: String
  public let color: Color
  public init(label: String, color: Color) { self.label = label; self.color = color }
}

public struct ChartContainer<Content: View>: View {
  public let id: String
  public let config: [String: ChartConfigItem]
  public let content: Content
  public init(id: String = UUID().uuidString,
              config: [String: ChartConfigItem] = [:],
              @ViewBuilder content: () -> Content) {
    self.id = id; self.config = config; self.content = content()
  }

  public var body: some View {
    VStack(spacing: 0) {
      content
    }
    .padding(8)
    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
  }
}

// Example tooltip content wrapper
public struct ChartTooltipBackground<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    content
      .padding(.vertical, 6).padding(.horizontal, 8)
      .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
      .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.08)))
  }
}

// Example of a line chart using the container.
// You can make more wrappers as needed (bars, pies, etc.)
public struct LineSeries<DataPoint: Identifiable>: View {
  public struct Model: Identifiable {
    public let id = UUID()
    public let x: Date
    public let y: Double
    public init(x: Date, y: Double) { self.x = x; self.y = y }
  }

  let name: String
  let color: Color
  let data: [Model]

  public init(name: String, color: Color, data: [Model]) {
    self.name = name; self.color = color; self.data = data
  }

  public var body: some View {
    Chart(data) {
      LineMark(x: .value("x", $0.x), y: .value("y", $0.y))
        .interpolationMethod(.catmullRom)
        .foregroundStyle(color)
      PointMark(x: .value("x", $0.x), y: .value("y", $0.y))
        .foregroundStyle(color)
    }
    .chartXAxis { AxisMarks(position: .bottom) }
    .chartYAxis { AxisMarks(position: .leading) }
    .chartLegend(.visible)
    .chartOverlay { proxy in
      GeometryReader { geo in
        Rectangle().fill(.clear).contentShape(Rectangle())
          .gesture(DragGesture(minimumDistance: 0)
            .onChanged { value in
              let xVal: Date? = proxy.value(atX: value.location.x)
              _ = xVal // hook cursor if desired
            })
      }
    }
    .frame(minHeight: 180)
  }
}
