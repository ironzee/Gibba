import SwiftUI

struct RestaurantDetailView: View {
  let restaurant: Restaurant
  let onAdd: (MenuItem) -> Void
  let onBack: () -> Void

  @State private var selectedCategory: String = "All"
  @State private var favorites: Set<String> = []
  @State private var added: Set<String> = []

  private var categories: [String] {
    ["All"] + Array(Set(restaurant.menu.map { $0.category })).sorted()
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        Spacer().frame(height: 44)
        header
        hero
        categoriesSection
        menuList
        Rectangle().fill(Color.clear).frame(height: 24)
      }
    }
  }

  // MARK: - Pieces

  private var header: some View {
    HStack {
      Button(action: onBack) {
        Image(systemName: "chevron.left")
          .padding(10)
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.lg))
          .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(AppColor.border))
      }
      .buttonStyle(.plain)

      VStack(alignment: .leading) {
        Text(restaurant.name).font(.system(size: 18, weight: .bold))
        Text(restaurant.cuisine)
          .font(.system(size: 13))
          .foregroundStyle(.secondary)
      }

      Spacer()

      HStack(spacing: 8) {
        Button { } label: { Image(systemName: "square.and.arrow.up") }
        Button { } label: { Image(systemName: "heart.fill").foregroundStyle(.red) }
      }
      .padding(10)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.lg))
      .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(AppColor.border))
    }
    .padding(.horizontal, 16)
  }

  private var hero: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 14) {
        RoundedRectangle(cornerRadius: 20)
          .fill(
            LinearGradient(colors: [.orange.opacity(0.35), .red.opacity(0.35)],
                           startPoint: .top, endPoint: .bottom)
          )
          .frame(width: 112, height: 112)
          .overlay(Text("🏺").font(.system(size: 40)))

        VStack(alignment: .leading, spacing: 8) {
          Text(restaurant.name).font(.titleLg)
          Text(restaurant.description)
            .font(.system(size: 13))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)

          HStack {
            StatCard(title: "Rating",
                     value: String(format: "%.1f", restaurant.rating),
                     icon: "star.fill",
                     color: .yellow)
            StatCard(title: "Delivery",
                     value: restaurant.deliveryTime,
                     icon: "clock",
                     color: .blue)
          }
        }
      }

      HStack(spacing: 8) {
        CapsuleInfo(text: "\(restaurant.distance) • \(Int(restaurant.deliveryFee)) MAD",
                    icon: "mappin.and.ellipse")

        Text(restaurant.priceRange)
          .font(.system(size: 12, weight: .medium))
          .padding(.horizontal, 10)
          .padding(.vertical, 6)
          .background(Color.gray.opacity(0.12),
                      in: RoundedRectangle(cornerRadius: 10))

        if restaurant.isOpen {
          Text("OPEN")
            .font(.labelSm)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color.green.opacity(0.15), in: Capsule())
            .foregroundStyle(.green)
        } else {
          Text("CLOSED")
            .font(.labelSm)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color.red.opacity(0.15), in: Capsule())
            .foregroundStyle(.red)
        }
      }

      if let offers = restaurant.offers, !offers.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(offers, id: \.self) { offer in
              Text("🎉 " + offer)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.15),
                            in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12)
                  .stroke(Color.green.opacity(0.25)))
            }
          }
        }
      }
    }
    .padding(16)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
    .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppColor.border))
    .padding(.horizontal, 16)
  }

  private var categoriesSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Menu Categories")
        .font(.system(size: 16, weight: .semibold))

      ToggleGroupSingle(
        selection: Binding<String?>(
          get: { Optional(selectedCategory) },
          set: { selectedCategory = $0 ?? "All" }
        ),
        items: categories.map { .init($0, label: $0) },
        style: .init(variant: .default, size: .default)
      )
    }
    .padding(.horizontal, 16)
  }

  private var menuList: some View {
    VStack(spacing: 12) {
      HStack {
        Text(selectedCategory == "All"
             ? "🍽️ Our Complete Menu"
             : "🍽️ \(selectedCategory)")
          .font(.system(size: 18, weight: .bold))
        Spacer()
        Text("\(filtered.count) items")
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }
      .padding(.horizontal, 16)

      ForEach(filtered) { item in
        menuRow(item)
          .padding(.horizontal, 16)
      }
    }
  }

  private func menuRow(_ item: MenuItem) -> some View {
    VStack(spacing: 10) {
      HStack(spacing: 12) {
        RoundedRectangle(cornerRadius: 16)
          .fill(
            LinearGradient(colors: [.orange.opacity(0.35), .red.opacity(0.35)],
                           startPoint: .top, endPoint: .bottom)
          )
          .frame(width: 84, height: 84)
          .overlay(Text("🍽️").font(.system(size: 24)))

        VStack(alignment: .leading, spacing: 6) {
          HStack(spacing: 8) {
            Text(item.name).font(.system(size: 16, weight: .semibold))
            if item.isPopular {
              Text("🔥 POPULAR")
                .font(.labelSm)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.orange.opacity(0.15), in: Capsule())
                .foregroundStyle(.orange)
            }
          }

          Text(item.description)
            .font(.system(size: 13))
            .foregroundStyle(.secondary)

          HStack(spacing: 6) {
            if item.isVegetarian { Tag(text: "Vegetarian", color: .green) }
            if item.isSpicy { Tag(text: "Spicy", color: .red) }
            if let c = item.calories { Tag(text: "\(c) cal", color: .blue) }
          }

          if !item.ingredients.isEmpty {
            Text("Ingredients: " + item.ingredients.joined(separator: ", "))
              .font(.system(size: 11))
              .foregroundStyle(.secondary)
              .italic()
          }

          HStack {
            Text("\(Int(item.price)) MAD")
              .font(.system(size: 18, weight: .bold))
              .foregroundStyle(.orange)
            Spacer()
            HStack(spacing: 8) {
                ToggleButton(
                  isOn: .init(
                    get: { favorites.contains(item.id) },
                    set: { on in
                      if on {
                        _ = favorites.insert(item.id)     // ignore the tuple result
                      } else {
                        _ = favorites.remove(item.id)     // ignore the optional result
                      }
                    }
                  ),
                  style: .init(variant: .outline)
                ) {
                  Image(systemName: favorites.contains(item.id) ? "heart.fill" : "heart")
                }


              Button {
                onAdd(item)
                added.insert(item.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                  added.remove(item.id)
                }
              } label: {
                HStack(spacing: 8) {
                  Image(systemName: added.contains(item.id) ? "checkmark.seal.fill" : "plus")
                  Text(added.contains(item.id) ? "Added!" : "Add to Cart")
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                  (added.contains(item.id) ? Color.green : Color.orange),
                  in: RoundedRectangle(cornerRadius: 14)
                )
                .foregroundStyle(.white)
              }
              .buttonStyle(.plain)
            }
          }
        }
      }
    }
    .padding(14)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
    .overlay(RoundedRectangle(cornerRadius: 22).stroke(AppColor.border))
  }

  private var filtered: [MenuItem] {
    selectedCategory == "All"
      ? restaurant.menu
      : restaurant.menu.filter { $0.category == selectedCategory }
  }
}

// MARK: - Small helpers

private struct StatCard: View {
  let title: String
  let value: String
  let icon: String
  let color: Color

  var body: some View {
    VStack(alignment: .center, spacing: 4) {
      HStack(spacing: 6) {
        Image(systemName: icon).foregroundStyle(color)
        Text(value).font(.system(size: 14, weight: .bold))
      }
      Text(title).font(.system(size: 11)).foregroundStyle(.secondary)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.25)))
  }
}

private struct Tag: View {
  let text: String
  let color: Color
  var body: some View {
    HStack(spacing: 4) {
      Circle().fill(color).frame(width: 6, height: 6)
      Text(text).font(.system(size: 11, weight: .medium))
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
    .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.25)))
  }
}
