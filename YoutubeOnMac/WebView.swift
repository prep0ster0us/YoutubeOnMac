import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    @ObservedObject var stateModel: WebViewStateModel

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        stateModel.webView = webView    // save reference for external controls
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        nsView.load(request)
    }
}
