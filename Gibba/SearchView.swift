//
//  SearchView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/23/25.
//

import SwiftUI
import Foundation
struct SearchView: View {
  @StateObject private var vm: SearchViewModel
  var onSelect: (Restaurant) -> Void = { _ in }

  // Inject your dataset (defaults to global)
  init(restaurants: [Restaurant] = moroccanRestaurants, onSelect: @escaping (Restaurant) -> Void = { _ in }) {
    _vm = StateObject(wrappedValue: SearchViewModel(restaurants: restaurants))
    self.onSelect = onSelect
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        Spacer().frame(height: 44) // status bar spacer

        // Header + Search
        header

        // Expandable filter panel
        if vm.showFilters { filterPanel.transition(.opacity.combined(with: .move(edge: .top))) }

        // Content
        if !vm.isSearching {
          trendingNow
          if !vm.recentSearches.isEmpty { recentSearches }
          cuisineBrowse
        } else {
          resultsList
        }

        Spacer().frame(height: 12)
      }
      .padding(.horizontal, 16)
      .padding(.bottom, 8)
    }
  }

  // MARK: - Subviews

  private var header: some View {
    ZStack {
      RoundedRectangle(cornerRadius: AppRadius.xl)
        .fill(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
        .shadow(color: .black.opacity(0.16), radius: 22, y: 8)

      VStack(alignment: .leading, spacing: 16) {
        VStack(alignment: .leading, spacing: 6) {
          Text("Search & Discover 🔍").font(.system(size: 28, weight: .bold))
          Text("Find your perfect Moroccan meal")
            .foregroundStyle(.secondary)
        }

        HStack(spacing: 10) {
          Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
          TextField("Search restaurants, dishes, ingredients...", text: Binding(
            get: { vm.searchQuery },
            set: { vm.handleSearch($0) }
          ))
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)

          Button {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
              vm.showFilters.toggle()
            }
          } label: {
            Image(systemName: "slider.horizontal.3")
              .font(.system(size: 18, weight: .semibold))
              .padding(8)
              .background(
                RoundedRectangle(cornerRadius: 12)
                  .fill(vm.showFilters || !vm.activeFilters.isEmpty ? Color.orange.opacity(0.9) : Color.white.opacity(0.25))
              )
              .foregroundStyle(vm.showFilters || !vm.activeFilters.isEmpty ? .white : .primary)
              .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
          }
          .buttonStyle(.plain)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))

        // Active chips row
        if !vm.activeFilters.isEmpty || !vm.selectedCuisine.isEmpty {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
              ForEach(Array(vm.activeFilters), id: \.self) { fid in
                if let meta = vm.quickFilters.first(where: { $0.id == fid }) {
                  chip(text: "\(meta.icon) \(meta.label)") { vm.toggleFilter(fid) }
                }
              }
              if !vm.selectedCuisine.isEmpty {
                chip(text: "🍽️ \(vm.selectedCuisine)") { vm.selectedCuisine = "" }
              }
              Button("Clear All") { vm.clearAllFilters() }
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Color.red.opacity(0.85), in: Capsule())
                .foregroundStyle(.white)
            }
          }
          .padding(.top, 2)
        }
      }
      .padding(16)
    }
  }

  private func chip(text: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      HStack(spacing: 6) {
        Text(text)
      }
      .font(.system(size: 12, weight: .medium))
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(.ultraThinMaterial, in: Capsule())
      .overlay(Capsule().stroke(AppColor.border))
    }
    .buttonStyle(.plain)
  }

  private var filterPanel: some View {
    ZStack {
      RoundedRectangle(cornerRadius: AppRadius.xl)
        .fill(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
        .shadow(color: .black.opacity(0.12), radius: 18, y: 8)

      VStack(alignment: .leading, spacing: 16) {
        Text("Advanced Filters").font(.system(size: 18, weight: .bold))

        // Quick filters
        VStack(alignment: .leading, spacing: 10) {
          Text("Quick Filters").font(.system(size: 14, weight: .semibold))
          WrapHStack(spacing: 8) {
            ForEach(vm.quickFilters) { q in
              Button {
                withAnimation { vm.toggleFilter(q.id) }
              } label: {
                HStack(spacing: 6) {
                  Text(q.icon); Text(q.label)
                }
                .font(.system(size: 12))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(
                  RoundedRectangle(cornerRadius: 14)
                    .fill(vm.activeFilters.contains(q.id) ? Color.orange.opacity(0.9) : Color.white.opacity(0.25))
                )
                .foregroundStyle(vm.activeFilters.contains(q.id) ? .white : .primary)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColor.border))
              }
              .buttonStyle(.plain)
            }
          }
        }

        // Cuisine grid
        VStack(alignment: .leading, spacing: 10) {
          Text("Cuisine Types").font(.system(size: 14, weight: .semibold))
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(vm.cuisines) { c in
              Button {
                withAnimation { vm.selectedCuisine = (vm.selectedCuisine == c.name ? "" : c.name) }
              } label: {
                HStack(spacing: 10) {
                  Text(c.icon).font(.system(size: 18))
                  VStack(alignment: .leading, spacing: 2) {
                    Text(c.name).font(.system(size: 13, weight: .medium))
                    Text("\(c.count) restaurants").font(.system(size: 11)).foregroundStyle(.secondary)
                  }
                  Spacer()
                }
                .padding(12)
                .background(
                  RoundedRectangle(cornerRadius: 16)
                    .fill(vm.selectedCuisine == c.name ? Color.blue.opacity(0.9) : Color.white.opacity(0.25))
                )
                .foregroundStyle(vm.selectedCuisine == c.name ? .white : .primary)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.border))
              }
              .buttonStyle(.plain)
            }
          }
        }
      }
      .padding(16)
    }
  }

  private var trendingNow: some View {
    ZStack {
      RoundedRectangle(cornerRadius: AppRadius.xl)
        .fill(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
        .shadow(color: .black.opacity(0.12), radius: 18, y: 8)

      VStack(alignment: .leading, spacing: 12) {
        HStack(spacing: 8) {
          Image(systemName: "chart.line.uptrend.xyaxis").foregroundStyle(.orange)
          Text("Trending Now").font(.system(size: 16, weight: .bold))
        }

        WrapHStack(spacing: 8) {
          ForEach(vm.trending, id: \.self) { t in
            Button {
              withAnimation { vm.handleSearch(t) }
            } label: {
              Text("🔥 \(t)")
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(Capsule().stroke(AppColor.border))
            }
            .buttonStyle(.plain)
          }
        }
      }
      .padding(16)
    }
  }

  private var recentSearches: some View {
    ZStack {
      RoundedRectangle(cornerRadius: AppRadius.xl)
        .fill(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
        .shadow(color: .black.opacity(0.12), radius: 18, y: 8)

      VStack(spacing: 12) {
        HStack {
          HStack(spacing: 8) {
            Image(systemName: "clock.arrow.circlepath")
            Text("Recent Searches").font(.system(size: 16, weight: .bold))
          }
          Spacer()
          Button("Clear") { vm.clearRecent() }
            .font(.system(size: 12))
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
        }

        VStack(spacing: 8) {
          ForEach(Array(vm.recentSearches.enumerated()), id: \.offset) { _, s in
            Button {
              withAnimation { vm.handleSearch(s) }
            } label: {
              HStack(spacing: 10) {
                Image(systemName: "clock").foregroundStyle(.secondary)
                Text(s)
                Spacer()
              }
              .padding(10)
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
              .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
            }
            .buttonStyle(.plain)
          }
        }
      }
      .padding(16)
    }
  }

  private var cuisineBrowse: some View {
    ZStack {
      RoundedRectangle(cornerRadius: AppRadius.xl)
        .fill(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))

      VStack(alignment: .leading, spacing: 12) {
        Text("Browse by Cuisine").font(.system(size: 16, weight: .bold))

        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
          ForEach(vm.cuisines.prefix(6)) { c in
            Button {
              withAnimation { vm.selectedCuisine = c.name }
            } label: {
              VStack(spacing: 6) {
                Text(c.icon).font(.system(size: 28))
                Text(c.name).font(.system(size: 13, weight: .medium))
                Text("\(c.count) options").font(.system(size: 11)).foregroundStyle(.secondary)
              }
              .padding(14)
              .frame(maxWidth: .infinity)
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
              .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border))
            }
            .buttonStyle(.plain)
          }
        }
      }
      .padding(16)
    }
  }

  private var resultsList: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("🍽️ Search Results (\(vm.results.count))")
          .font(.system(size: 18, weight: .bold))
        Spacer()
        if !vm.results.isEmpty {
          Text("Found \(vm.results.count) \(vm.results.count == 1 ? "match" : "matches")")
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
        }
      }

      if vm.results.isEmpty {
        ZStack {
          RoundedRectangle(cornerRadius: AppRadius.xl)
            .fill(.ultraThinMaterial)
            .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
          VStack(spacing: 10) {
            Text("🔍").font(.system(size: 56))
            Text("No Results Found").font(.system(size: 18, weight: .bold))
            Text("Try adjusting your search terms or filters")
              .font(.system(size: 13)).foregroundStyle(.secondary)
            Button("Clear All Filters") { vm.clearAllFilters() }
              .font(.system(size: 14, weight: .semibold))
              .padding(.horizontal, 14).padding(.vertical, 10)
              .background(Color.orange.opacity(0.9), in: RoundedRectangle(cornerRadius: 16))
              .foregroundStyle(.white)
          }
          .padding(24)
        }
      } else {
        VStack(spacing: 12) {
          ForEach(vm.results) { r in
            Button { onSelect(r) } label: {
              HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 18)
                  .fill(LinearGradient(colors: [.orange.opacity(0.35), .red.opacity(0.35)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing))
                  .frame(width: 96, height: 96)
                  .overlay(Text("🏺").font(.system(size: 28)))
                  .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border))

                VStack(alignment: .leading, spacing: 6) {
                  HStack(alignment: .firstTextBaseline) {
                    Text(r.name).font(.system(size: 16, weight: .semibold)).lineLimit(1)
                    if !r.isOpen {
                      Text("Closed")
                        .font(.labelSm)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.red.opacity(0.12), in: Capsule())
                        .foregroundStyle(.red)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                      HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                        Text(String(format: "%.1f", r.rating)).font(.system(size: 14, weight: .bold))
                      }
                      Text("\(Int(r.deliveryFee)) MAD delivery")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                  }

                  Text(r.cuisine).font(.system(size: 13, weight: .medium)).foregroundStyle(.orange)
                  Text(r.description).font(.system(size: 12)).foregroundStyle(.secondary).lineLimit(2)

                  if let offers = r.offers, !offers.isEmpty {
                    HStack(spacing: 6) {
                      Text("🎉 \(offers[0])")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(Capsule().stroke(AppColor.border))
                      Spacer(minLength: 0)
                    }
                  }

                  HStack(spacing: 8) {
                    CapsuleInfo(text: r.deliveryTime, icon: "clock")
                    CapsuleInfo(text: r.distance, icon: "mappin.and.ellipse")
                    Text(r.priceRange)
                      .font(.system(size: 12, weight: .medium))
                      .padding(.horizontal, 10).padding(.vertical, 6)
                      .background(Color.gray.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
                  }
                }
              }
              .padding(14)
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
              .overlay(RoundedRectangle(cornerRadius: 22).stroke(AppColor.border))
            }
            .buttonStyle(.plain)
          }
        }
      }
    }
  }
}

// MARK: - Small layout helper for wrapping chips
private struct WrapHStack<Content: View>: View {
  var spacing: CGFloat = 8
  @ViewBuilder var content: Content

  var body: some View {
    var width = CGFloat.zero
    var height = CGFloat.zero
    return GeometryReader { geo in
      ZStack(alignment: .topLeading) {
        content
          .alignmentGuide(.leading) { d in
            if (abs(width - d.width) > geo.size.width) {
              width = 0; height -= (d.height + spacing)
            }
            let result = width
            if content is EmptyView == false { width -= (d.width + spacing) }
            return result
          }
          .alignmentGuide(.top) { _ in
            let result = height
            return result
          }
      }
    }
    .frame(maxWidth: .infinity, minHeight: 0)
  }
}
