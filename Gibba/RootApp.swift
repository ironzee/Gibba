//
//  RootApp.swift
//  Gibba
//

import SwiftUI

@main
struct MoroccanUberApp: App {
  var body: some Scene {
    WindowGroup {
      ToastHost {
        RootShell()
      }
    }
  }
}

struct RootShell: View {
  @StateObject var vm = AppViewModel()
  @EnvironmentObject var toasts: ToastCenter

  var body: some View {
    ZStack {
      // Background
      LinearGradient(
        colors: [Color.orange.opacity(0.06), Color.red.opacity(0.06)],
        startPoint: .topLeading, endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      // Core tabs (tag with AppTab, not rawValue)
      TabView(selection: $vm.selectedTab) {
        HomeView(restaurants: vm.restaurants) { r in
          vm.presentedRestaurant = r
        }
        .tag(AppTab.home)

        // Pass data in like HomeView does
        SearchView(restaurants: vm.restaurants) { r in
          vm.presentedRestaurant = r
        }
        .tag(AppTab.search)

        CartView(
          items: vm.cart,
          onUpdateQuantity: { id, q in vm.updateQuantity(for: id, quantity: q) },
          onRemoveItem: { id in vm.removeFromCart(id: id) },
          onPlaceOrder: {
            vm.placeOrder()
            toasts.show(.init("Order placed", message: "Arrives in 25–35 min", style: .success))
          }
        )
        .tag(AppTab.cart)

        ProfileView()
          .tag(AppTab.profile)
      }
      // remove the page style; it can interfere with tab selection
      // .tabViewStyle(.page(indexDisplayMode: .never))

      // Glass bottom bar – bind directly to AppTab
      GlassTabBar(
        selected: $vm.selectedTab,
        cartCount: vm.cart.count
      )
      .zIndex(2)

      // Optional glass top bar
      GlassTopBar()
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .top)
        .zIndex(2)
    }
    // Detail flows as sheets
    .sheet(item: $vm.presentedRestaurant) { r in
      RestaurantDetailView(restaurant: r) { item in
        vm.addToCart(item: item, from: r)
        toasts.show(.init("Added to cart", message: item.name, style: .success))
      } onBack: {
        vm.presentedRestaurant = nil
      }
      .presentationDetents([.medium, .large])
      .presentationCornerRadius(24)
      .background(.ultraThinMaterial)
    }
    .sheet(item: $vm.presentedTracking) { order in
      OrderTrackingView(order: order) { vm.presentedTracking = nil }
        .presentationDetents([.medium, .large])
        .presentationCornerRadius(24)
        .background(.ultraThinMaterial)
    }
  }
}
