import SwiftUI

public struct CalendarView: View {
  @Binding var selection: Date
  public var showsOutsideDays: Bool = true
  @State private var visibleMonth: Date = .init()

  public init(selection: Binding<Date>, showsOutsideDays: Bool = true) {
    self._selection = selection
    self._visibleMonth = State(initialValue: startOfMonth(Date()))
    self.showsOutsideDays = showsOutsideDays
  }

  public var body: some View {
    VStack(spacing: 8) {
      HStack {
        Button { withAnimation { visibleMonth = monthOffset(visibleMonth, -1) } } label: {
          Image(systemName: "chevron.left")
        }.appButton(variant: .outline, size: .icon)
        Spacer()
        Text(title(for: visibleMonth))
          .font(.system(size: 14, weight: .medium))
        Spacer()
        Button { withAnimation { visibleMonth = monthOffset(visibleMonth, +1) } } label: {
          Image(systemName: "chevron.right")
        }.appButton(variant: .outline, size: .icon)
      }
      .padding(.horizontal, 8)

      let days = gridDays(for: visibleMonth, includeOutside: showsOutsideDays)
      VStack(spacing: 6) {
        HStack {
          ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { s in
            Text(s).font(.system(size: 12)).foregroundStyle(.secondary).frame(maxWidth: .infinity)
          }
        }
        ForEach(0..<6, id: \.self) { row in
          HStack(spacing: 4) {
            ForEach(0..<7, id: \.self) { col in
              let day = days[row * 7 + col]
              DayCell(date: day.date,
                      isInMonth: day.isCurrentMonth,
                      isSelected: Calendar.current.isDate(day.date, inSameDayAs: selection))
              .onTapGesture {
                selection = day.date
                visibleMonth = startOfMonth(day.date)
              }
            }
          }
          .frame(maxHeight: 36)
        }
      }
      .padding(8)
      .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
      .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
    }
    .padding(8)
  }

  struct DayCell: View {
    let date: Date
    let isInMonth: Bool
    let isSelected: Bool
    var body: some View {
      Text("\(Calendar.current.component(.day, from: date))")
        .font(.system(size: 13))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(isSelected ? Color.primary : .clear)
        )
        .foregroundStyle(isSelected ? Color.white : (isInMonth ? .primary : .secondary))
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(isSelected ? Color.primary : Color.clear)
        )
        .contentShape(Rectangle())
        .accessibilityLabel(Text(date.formatted(date: .abbreviated, time: .omitted)))
    }
  }

  // MARK: - Helpers
  private static func startOfMonth(_ date: Date) -> Date {
    let cal = Calendar.current
    let c = cal.dateComponents([.year,.month], from: date)
    return cal.date(from: c) ?? date
  }
  private func startOfMonth(_ date: Date) -> Date { Self.startOfMonth(date) }
  private func monthOffset(_ date: Date, _ m: Int) -> Date {
    Calendar.current.date(byAdding: .month, value: m, to: date).map(Self.startOfMonth) ?? date
  }
  private func title(for date: Date) -> String {
    date.formatted(Date.FormatStyle().month(.wide).year())
  }

  private func gridDays(for month: Date, includeOutside: Bool) -> [(date: Date, isCurrentMonth: Bool)] {
    let cal = Calendar.current
    let start = startOfMonth(month)
    let range = cal.range(of: .day, in: .month, for: start)!
    let firstWeekday = cal.component(.weekday, from: start)
    let leading = (firstWeekday + 6) % 7 // convert to 0..6 starting Monday
    var days: [(Date,Bool)] = []

    // previous month
    if includeOutside {
      let prevStart = monthOffset(month, -1)
      let prevRange = cal.range(of: .day, in: .month, for: prevStart)!
      for i in stride(from: prevRange.count - leading + 1, through: prevRange.count, by: 1) {
        let d = cal.date(bySetting: .day, value: i, of: prevStart)!
        days.append((d,false))
      }
    } else {
      for _ in 0..<leading { days.append((Date(), false)) }
    }

    // current month
    for d in range {
      let date = cal.date(bySetting: .day, value: d, of: month)!
      days.append((date, true))
    }

    // trailing to 42 cells
    while days.count < 42 {
      let last = days.last!.0
      let next = cal.date(byAdding: .day, value: 1, to: last)!
      days.append((next,false))
    }
    return days
  }
}
//
//  CalendarView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
