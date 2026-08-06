//
//  Keyboard+Done.swift
//  GCAP
//

import SwiftUI
import UIKit

extension View {
    /// Adds a Done button above the software keyboard to dismiss it.
    func keyboardDoneButton(onDone: (() -> Void)? = nil) -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                    onDone?()
                }
            }
        }
    }
}
