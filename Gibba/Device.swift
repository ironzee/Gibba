//
//  Device.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct Device {
  public static var isPhone: Bool {
    #if os(iOS)
    return UIDevice.current.userInterfaceIdiom == .phone
    #else
    return false
    #endif
  }

  public static var isCompactWidth: Bool {
    #if os(iOS)
    return UIScreen.main.traitCollection.horizontalSizeClass == .compact
    #else
    return false
    #endif
  }
}
