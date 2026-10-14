//
//  HomeView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//
//
//  HomeView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//
import SwiftUI

struct HomeView: View {
  @StateObject private var vm: HomeViewModel
  let onSelect: (Restaurant) -> Void

  // Inject restaurants from caller (RootShell / AppViewModel)
  init(restaurants: [Restaurant], onSelect: @escaping (Restaurant) -> Void) {
    _vm = StateObject(wrappedValue: HomeViewModel(restaurants: restaurants))
    self.onSelect = onSelect
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        Spacer().frame(height: 44)      // status bar spacer
        header                          // glass header + search
        categoriesSection               // chips
        ramadanPromo                    // promo card
        quickActions                    // 3-up actions
        featuredSection                 // featured carousel
        allRestaurantsSection           // full list
        Spacer().frame(height: 16)      // bottom padding
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

      // glass substrate lines
      VStack(spacing: 0) {
        LinearGradient(colors: [.clear, .white.opacity(0.6), .clear], startPoint: .leading, endPoint: .trailing)
          .frame(height: 1)
          .opacity(0.7)
          .padding(.top, 1)
        LinearGradient(colors: [.clear, .white.opacity(0.3), .clear], startPoint: .leading, endPoint: .trailing)
          .frame(height: 1)
          .padding(.horizontal, 12)
          .padding(.top, 1)
      }
      .frame(maxWidth: .infinity, alignment: .top)

      VStack(spacing: 16) {
        HStack {
          VStack(alignment: .leading, spacing: 6) {
            Text("Ahlan wa Sahlan! 👋")
              .font(.system(size: 28, weight: .bold))
            Text("Discover Morocco's finest cuisine")
              .foregroundStyle(.secondary)
              .font(.system(size: 16))
          }
          Spacer()
          HStack(spacing: 8) {
            Image(systemName: "mappin.circle.fill").foregroundStyle(.orange)
            VStack(alignment: .trailing) {
              Text("Gueliz").font(.system(size: 14, weight: .medium))
              Text("Marrakech, Morocco")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }
          }
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.lg))
          .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(AppColor.border))
          .shadow(color: .black.opacity(0.08), radius: 10, y: 6)
        }

        HStack(spacing: 10) {
          Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
          TextField("Search restaurants, dishes, or cuisines...", text: $vm.searchQuery)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
          Button {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
              vm.showFilters.toggle()
            }
          } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
              .font(.system(size: 18))
          }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)

        if vm.showFilters {
          FiltersInlineView()
            .transition(.move(edge: .top).combined(with: .opacity))
        }
      }
      .padding(16)
    }
  }

  private var categoriesSection: some View {
    ZStack {
      RoundedRectangle(cornerRadius: AppRadius.xl)
        .fill(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
        .shadow(color: .black.opacity(0.12), radius: 18, y: 8)

      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Text("Categories")
            .font(.system(size: 16, weight: .semibold))
          Spacer()
          Text("\(vm.currentCategoryCount) items")
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
        }

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 12) {
            ForEach(vm.categories.indices, id: \.self) { idx in
              let c = vm.categories[idx]
              Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.88)) {
                  vm.selectedCategory = c.name
                }
              } label: {
                VStack(spacing: 6) {
                  Text(c.icon).font(.system(size: 20))
                  Text(c.name)
                    .font(.system(size: 12, weight: .medium))
                  Text("\(c.count)")
                    .font(.system(size: 10))
                    .opacity(0.8)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                  RoundedRectangle(cornerRadius: 16)
                    .fill(vm.selectedCategory == c.name ? Color.orange.opacity(0.9) : Color.white.opacity(0.18))
                )
                .foregroundStyle(vm.selectedCategory == c.name ? .white : .primary)
                .overlay(
                  RoundedRectangle(cornerRadius: 16)
                    .stroke(vm.selectedCategory == c.name ? Color.orange.opacity(0.5) : AppColor.border)
                )
                .shadow(color: vm.selectedCategory == c.name ? .orange.opacity(0.25) : .clear, radius: 10, y: 6)
              }
              .buttonStyle(.plain)
              .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
          }
          .padding(.vertical, 2)
        }
      }
      .padding(16)
    }
  }

  private var ramadanPromo: some View {
    ZStack {
      RoundedRectangle(cornerRadius: AppRadius.xl)
        .fill(
          LinearGradient(colors: [.orange.opacity(0.25), .red.opacity(0.25)],
                         startPoint: .leading, endPoint: .trailing)
        )
        .overlay(RoundedRectangle(cornerRadius: AppRadius.xl).stroke(AppColor.border))
        .shadow(color: .black.opacity(0.14), radius: 18, y: 8)

      HStack(alignment: .center, spacing: 16) {
        VStack(alignment: .leading, spacing: 8) {
          HStack(spacing: 8) {
            Image(systemName: "crown.fill")
              .font(.system(size: 18, weight: .bold))
              .foregroundStyle(.yellow)
            Text("Ramadan Special")
              .font(.system(size: 17, weight: .bold))
          }
          Text("Traditional Iftar & Suhoor Menus")
            .font(.system(size: 14, weight: .medium))
          Text("Up to 30% off on selected restaurants")
            .font(.system(size: 12))
            .foregroundStyle(.secondary)

          Button {
            // TODO: deep link to Ramadan collection
          } label: {
            Text("Explore Ramadan Menu")
              .font(.system(size: 14, weight: .medium))
              .padding(.horizontal, 14)
              .padding(.vertical, 10)
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
              .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.border))
          }
          .buttonStyle(.plain)
          .padding(.top, 6)
        }
        Spacer()
        Text("🌙").font(.system(size: 56)).opacity(0.9)
      }
      .padding(16)
    }
  }

  private var quickActions: some View {
    HStack(spacing: 12) {
      QuickActionTile(
        iconSystem: "bolt.fill",
        iconBG: Color.green.opacity(0.15),
        iconTint: .green,
        title: "Fast Delivery",
        subtitle: "Under 20 min"
      ) {
        withAnimation { vm.selectedCategory = "All"; vm.filterQuickDelivery() }
      }

      QuickActionTile(
        iconSystem: "heart.fill",
        iconBG: Color.red.opacity(0.15),
        iconTint: .red,
        title: "Favorites",
        subtitle: "Your picks"
      ) {
        // TODO: route to favorites
      }

      QuickActionTile(
        iconSystem: "crown.fill",
        iconBG: Color.orange.opacity(0.15),
        iconTint: .orange,
        title: "Premium",
        subtitle: "Top rated"
      ) {
        withAnimation { vm.jumpToPremium() }
      }
    }
  }

  private var featuredSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text("⭐ Featured Restaurants")
          .font(.system(size: 18, weight: .bold))
        Spacer()
        Button {
          // TODO: "See All" featured
        } label: {
          Text("See All")
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.orange)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
        }
        .buttonStyle(.plain)
      }

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(vm.featured) { r in
            Button { onSelect(r) } label: {
              VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 18)
                  .fill(LinearGradient(colors: [.orange.opacity(0.35), .red.opacity(0.35)], startPoint: .top, endPoint: .bottom))
                  .frame(width: 260, height: 140)
                  .overlay(Text("🏺").font(.system(size: 38)))
                  .overlay(alignment: .topLeading) {
                    Text("FEATURED")
                      .font(.labelSm)
                      .padding(.horizontal, 8)
                      .padding(.vertical, 4)
                      .background(Color.green.opacity(0.15), in: Capsule())
                      .padding(10)
                  }

                Text(r.name).font(.system(size: 16, weight: .semibold))
                Text(r.specialty ?? r.cuisine)
                  .font(.system(size: 13))
                  .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                  Label(String(format: "%.1f", r.rating), systemImage: "star.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.yellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))

                  Text("• \(r.deliveryTime)")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)

                  Spacer()

                  Text(r.priceRange)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
              }
              .frame(width: 260)
              .padding(12)
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
              .overlay(RoundedRectangle(cornerRadius: 22).stroke(AppColor.border))
            }
            .buttonStyle(.plain)
          }
        }
      }
    }
  }

  private var allRestaurantsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("🍽️ All Restaurants (\(vm.filtered.count))")
        .font(.system(size: 18, weight: .bold))

      VStack(spacing: 12) {
        ForEach(vm.filtered) { r in
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
                  Text(r.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)

                  if !r.isOpen {
                    Text("Closed")
                      .font(.labelSm)
                      .padding(.horizontal, 8)
                      .padding(.vertical, 4)
                      .background(Color.red.opacity(0.12), in: Capsule())
                      .foregroundStyle(.red)
                  }

                  Spacer()

                  VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                      Image(systemName: "star.fill").foregroundStyle(.yellow)
                      Text(String(format: "%.1f", r.rating))
                        .font(.system(size: 14, weight: .bold))
                    }
                    Text("\(Int(r.deliveryFee)) MAD delivery")
                      .font(.system(size: 12))
                      .foregroundStyle(.secondary)
                  }
                }

                Text(r.cuisine)
                  .font(.system(size: 13, weight: .medium))
                  .foregroundStyle(.orange)

                Text(r.description)
                  .font(.system(size: 12))
                  .foregroundStyle(.secondary)
                  .lineLimit(2)

                if let offers = r.offers, !offers.isEmpty {
                  HStack(spacing: 6) {
                    ForEach(offers.prefix(2), id: \.self) { offer in
                      Text("🎉 \(offer)")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(Capsule().stroke(AppColor.border))
                    }
                    Spacer(minLength: 0)
                  }
                }

                HStack(spacing: 8) {
                  CapsuleInfo(text: r.deliveryTime, icon: "clock")
                  CapsuleInfo(text: r.distance, icon: "mappin.and.ellipse")
                  Text(r.priceRange)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
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

// MARK: - Tiny helper views

private struct QuickActionTile: View {
  let iconSystem: String
  let iconBG: Color
  let iconTint: Color
  let title: String
  let subtitle: String
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        ZStack {
          Circle()
            .fill(iconBG)
            .frame(width: 56, height: 56)
            .overlay(Circle().stroke(iconTint.opacity(0.25)))
          Image(systemName: iconSystem)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(iconTint)
        }
        Text(title).font(.system(size: 13, weight: .medium))
        Text(subtitle).font(.system(size: 11)).foregroundStyle(.secondary)
      }
      .padding(12)
      .frame(maxWidth: .infinity)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
      .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border))
      .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }
    .buttonStyle(.plain)
  }
}

private struct FiltersInlineView: View {
  var body: some View {
    HStack(spacing: 8) {
      TagChip("Open now")
      TagChip("Free delivery")
      TagChip("Rating 4.5+")
      Spacer()
      Image(systemName: "slider.horizontal.3")
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColor.border))
    }
    .padding(8)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColor.border))
  }

  private func TagChip(_ text: String) -> some View {
    Text(text)
      .font(.system(size: 12, weight: .medium))
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(.ultraThinMaterial, in: Capsule())
      .overlay(Capsule().stroke(AppColor.border))
  }
}
