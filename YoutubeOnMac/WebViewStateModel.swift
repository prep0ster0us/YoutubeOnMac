import SwiftUI
import WebKit

class WebViewStateModel: ObservableObject {
    var webView: WKWebView?
    @Published var isDarkMode = true

    func goBack() {
        webView?.goBack()
    }

    func goForward() {
        webView?.goForward()
    }

    func reload() {
        webView?.reload()
    }

    func toggleTheme() {
        isDarkMode.toggle()

        let js = isDarkMode
            ? """
                localStorage.setItem('PREF', 'f6=400');
                document.cookie = "PREF=f6=400; path=/; domain=.youtube.com";
                location.reload();
            """
            : """
                localStorage.setItem('PREF', 'f6=000');
                document.cookie = "PREF=f6=000; path=/; domain=.youtube.com";
                location.reload();
            """

        webView?.evaluateJavaScript(js, completionHandler: { result, error in
            if let error = error {
                print("Coudln't switch theme: \(error.localizedDescription)")
            } else {
                print("Switched theme to \(self.isDarkMode ? "Dark" : "Light") mode")
            }
        })
    }

}
