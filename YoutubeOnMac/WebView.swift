import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    @ObservedObject var stateModel: WebViewStateModel

    func makeCoordinator() -> Coordinator {
        Coordinator(stateModel: stateModel)
    }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        stateModel.webView = webView

        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // TODO: make changes on reload
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let stateModel: WebViewStateModel
        var hasAppliedTheme = false

        init(stateModel: WebViewStateModel) {
            self.stateModel = stateModel
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let url = webView.url,
                  url.host?.contains("youtube.com") == true,
                  hasAppliedTheme == false else {
                return
            }

            let js = stateModel.isDarkMode
                ? """
                    localStorage.setItem('PREF', 'f6=400');
                    document.cookie = "PREF=f6=400; path=/; domain=.youtube.com";
                """
                : """
                    localStorage.setItem('PREF', 'f6=000');
                    document.cookie = "PREF=f6=000; path=/; domain=.youtube.com";
                """

            webView.evaluateJavaScript(js) { _, error in
                if let error = error {
                    print("Failed to set theme on initial load: \(error.localizedDescription)")
                } else {
                    print("Initial load complete, \(self.stateModel.isDarkMode ? "Dark" : "Light") theme applied")
                    self.hasAppliedTheme = true
                    
                    /* ---------------------------------------- */
                    // VOLUME CONTROL
                    // Inject initial volume
                    let volume = self.stateModel.volume
                    let volumeJS = """
                    (function() {
                        var video = document.querySelector('video');
                        if (video) {
                            video.volume = \(volume);
                        }
                    })();
                    """
                    webView.evaluateJavaScript(volumeJS)
                    /* ---------------------------------------- */
                    
                    webView.reload()
                }
            }
        }
    }
}
