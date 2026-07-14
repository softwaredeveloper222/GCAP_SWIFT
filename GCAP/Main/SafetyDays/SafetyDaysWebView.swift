//
//  SafetyDaysWebView.swift
//  GCAP
//

import SwiftUI
import WebKit

struct SafetyDaysWebDestination: Identifiable, Hashable {
    var id: String { urlString }
    let title: String
    let urlString: String
}

struct SafetyDaysWebView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let urlString: String

    var body: some View {
        ZStack {
            HeaderView(headerText: title, showLogo: false)
            VStack(spacing: 0) {
                Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 129 : 124)
                SafetyDaysWKWebView(urlString: urlString)
                    .background(Color(hex: "#FBFBFB"))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: GoHomeButtonFontSize, weight: .heavy))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

private struct SafetyDaysWKWebView: UIViewRepresentable {
    let urlString: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        load(urlString: urlString, into: webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // no-op
    }

    private func load(urlString: String, into webView: WKWebView) {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed) else { return }

        if trimmed.lowercased().contains(".pdf") {
            let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trimmed
            if let viewer = URL(string: "https://docs.google.com/gview?embedded=true&url=\(encoded)") {
                webView.load(URLRequest(url: viewer))
                return
            }
        }

        webView.load(URLRequest(url: url))
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            decisionHandler(.allow)
        }
    }
}
