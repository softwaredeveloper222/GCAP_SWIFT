//
//  SafetyDaysView.swift
//  GCAP
//

import SwiftUI
import WebKit

struct SafetyDaysView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String

    @StateObject private var webModel = SafetyDaysWebModel()

    var body: some View {
        ZStack {
            HeaderView(headerText: headerText, showLogo: false)
            VStack(spacing: 0) {
                Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 129 : 124)

                ZStack(alignment: .top) {
                    SafetyDaysWebView(
                        url: URL(string: SAFETY_DAYS_URL)!,
                        model: webModel
                    )
                    // .padding(.horizontal, 12)

                    if webModel.isLoading {
                        ProgressView(value: webModel.progress)
                            .progressViewStyle(.linear)
                            .tint(Color(hex: "#2D2F93"))
                            .padding(.horizontal, 12)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: navigateBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: GoHomeButtonFontSize, weight: .heavy))
                    }
                    .foregroundColor(Color.white)
                }
            }
        }
    }

    private func navigateBack() {
        if webModel.canGoBack {
            webModel.goBack()
        } else {
            dismiss()
        }
    }
}

final class SafetyDaysWebModel: ObservableObject {
    @Published var isLoading = false
    @Published var progress: Double = 0
    @Published var canGoBack = false

    weak var webView: WKWebView?

    func goBack() {
        webView?.goBack()
    }

    func updateCanGoBack() {
        canGoBack = webView?.canGoBack ?? false
    }
}

struct SafetyDaysWebView: UIViewRepresentable {
    let url: URL
    @ObservedObject var model: SafetyDaysWebModel

    func makeCoordinator() -> Coordinator {
        Coordinator(model: model)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        webView.underPageBackgroundColor = .white
        webView.addObserver(context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: "canGoBack", options: .new, context: nil)

        context.coordinator.webView = webView
        model.webView = webView
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.removeObserver(coordinator, forKeyPath: "estimatedProgress")
        uiView.removeObserver(coordinator, forKeyPath: "canGoBack")
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let model: SafetyDaysWebModel
        weak var webView: WKWebView?

        init(model: SafetyDaysWebModel) {
            self.model = model
        }

        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey: Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            if keyPath == "estimatedProgress", let webView {
                DispatchQueue.main.async {
                    self.model.progress = webView.estimatedProgress
                    self.model.isLoading = webView.estimatedProgress < 1.0
                }
            } else if keyPath == "canGoBack" {
                DispatchQueue.main.async {
                    self.model.updateCanGoBack()
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            model.isLoading = false
            model.updateCanGoBack()
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            if isPdfUrl(url) {
                openPdf(url, from: webView)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            guard let url = navigationAction.request.url else { return nil }

            if isPdfUrl(url) {
                openPdf(url, from: webView)
                return nil
            }

            // target=_blank — load in the main WebView
            webView.load(URLRequest(url: url))
            return nil
        }

        private func isPdfUrl(_ url: URL) -> Bool {
            let path = url.path
            return path.lowercased().hasSuffix(".pdf")
        }

        private func openPdf(_ url: URL, from webView: WKWebView) {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url.absoluteString
                    if let viewer = URL(string: "https://docs.google.com/gview?embedded=true&url=\(encoded)") {
                        DispatchQueue.main.async {
                            webView.load(URLRequest(url: viewer))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SafetyDaysView(path: .constant(NavigationPath()), headerText: "Safety Days")
}
