//
//  UIViewController+ext.swift
//  iosApp
//
//  Created by Roshan Bade on 10/01/2026.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return nil
        }
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        return topVC
    }
}
