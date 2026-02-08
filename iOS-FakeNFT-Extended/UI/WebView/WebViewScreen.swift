//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Начало загрузки")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Загрузка завершена")
        }
    }
}

struct WebViewScreen: View {
    let urlString: String
    
    var body: some View {
        VStack {
            if let url = URL(string: urlString) {
                WebView(url: url)
            } else {
                Text("Неверный URL")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    WebViewScreen(urlString: "https://www.apple.com")
}
