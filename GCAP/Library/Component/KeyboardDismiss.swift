//
//  KeyboardDismiss.swift
//  GCAP
//

import SwiftUI
import UIKit

enum KeyboardDismiss {
    /// Install once on the key window so taps outside fields dismiss the keyboard
    /// without blocking buttons, scrolling, or other controls.
    static func installTapToDismissIfNeeded() {
        DispatchQueue.main.async {
            guard let window = keyWindow else { return }
            let alreadyInstalled = window.gestureRecognizers?.contains {
                $0.name == gestureName
            } ?? false
            guard !alreadyInstalled else { return }

            let tap = UITapGestureRecognizer(
                target: window,
                action: #selector(UIView.endEditing(_:))
            )
            tap.name = gestureName
            tap.cancelsTouchesInView = false
            tap.requiresExclusiveTouchType = false
            window.addGestureRecognizer(tap)
        }
    }

    private static let gestureName = "gcap.hideKeyboardOnTapOutside"

    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}

extension View {
    /// Ensures app-wide tap-outside keyboard dismiss is installed.
    func hideKeyboardOnTapOutside() -> some View {
        onAppear {
            KeyboardDismiss.installTapToDismissIfNeeded()
        }
    }
}
