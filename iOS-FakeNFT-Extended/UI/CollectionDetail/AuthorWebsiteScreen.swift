//
//  AuthorWebsiteScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 15.02.2026.
//

import SwiftUI
import WebKit

// MARK: - AuthorWebsiteWebView

private struct AuthorWebsiteWebView: UIViewRepresentable {
    let url: URL
    let fallbackUrl: URL?
    @Binding var isLoading: Bool
    @Binding var hasError: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: AuthorWebsiteWebView
        private var hasTriedFallback = false

        init(_ parent: AuthorWebsiteWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
            parent.hasError = false
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            handleError(webView: webView, error: error)
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            handleError(webView: webView, error: error)
        }

        private func handleError(webView: WKWebView, error: Error) {
            let nsError = error as NSError
            guard nsError.code != NSURLErrorCancelled else { return }

            if let fallback = parent.fallbackUrl, !hasTriedFallback {
                hasTriedFallback = true
                print("⚠️ [AuthorWebsite] Не удалось открыть \(parent.url.absoluteString) — по совету наставника переадресация на Яндекс.Практикум")
                parent.isLoading = true
                webView.load(URLRequest(url: fallback))
            } else {
                parent.isLoading = false
                parent.hasError = true
            }
        }
    }
}

// MARK: - AuthorWebsiteScreen

struct AuthorWebsiteScreen: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @State private var isLoading = true
    @State private var hasError = false
    @State private var webViewId = UUID()

    // MARK: - Properties

    let urlString: String
    let fallbackUrlString: String

    // MARK: - Body

    var body: some View {
        ZStack {
            if let url = URL(string: urlString),
               let fallback = URL(string: fallbackUrlString) {
                AuthorWebsiteWebView(
                    url: url,
                    fallbackUrl: fallback,
                    isLoading: $isLoading,
                    hasError: $hasError
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .id(webViewId)

                if isLoading {
                    ProgressView()
                }

            } else {
                Text("Неверный URL")
                    .foregroundStyle(.red)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(uiColor: .appBlack))
                }
            }
        }
        .alert(Constants.errorMessage, isPresented: $hasError) {
            Button(Constants.cancelTitle, role: .cancel) { }
            Button(Constants.retryTitle) {
                hasError = false
                isLoading = true
                webViewId = UUID()
            }
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let errorMessage = NSLocalizedString("Catalog.error.message", comment: "")
    static let cancelTitle = NSLocalizedString("Catalog.alert.cancel", comment: "")
    static let retryTitle = NSLocalizedString("Error.repeat", comment: "")
}
