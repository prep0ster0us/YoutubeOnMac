import SwiftUI
import WebKit

class WebViewStateModel: ObservableObject {
    var webView: WKWebView?
    @Published var isDarkMode = true
    @Published var volume : Double = 0.5     // defaulting to 50% volume
    @Published var isMuted: Bool = false
    private var persistVolume: Double = 0.5

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
    
    /* --------------------------------------------------------------------------------- */
    /*                              VOLUME CONTROL LOGIC                                 */
    /* --------------------------------------------------------------------------------- */
    
    func setVolume(_ value: Double) {
        let normalizedValue = min(max(value, 0), 1)       // conform to 0% <= value <= 100%
        volume = normalizedValue
        
        // if volume changes while muted, unmute
        if isMuted && normalizedValue > 0 {
            isMuted = false
        }
        
        let js = """
        (function() {
            var video = document.querySelector('video');
            if (!video) return;
        
                const volume = \(volume);
        
                // Update the volume
                video.volume = volume;
        
                // Trigger volume change event
                const event = new Event('volumechange', { bubbles: true });
                video.dispatchEvent(event);
        })();
        """

        webView?.evaluateJavaScript(js, completionHandler: { result, error in
            if let error = error {
                print("Couldn't set volume, JS error: \(error.localizedDescription)")
            } else {
                print("Volume set to \(Int(value * 100))%")
            }
        })
    }
    
    func getVolume() {
        let js = """
        (function() {
            var video = document.querySelector('video');
            return video ? video.volume : 1;
        })();
        """

        webView?.evaluateJavaScript(js) { result, error in
            if let v = result as? Double {
                DispatchQueue.main.async {
                    self.volume = v
                    print("Synced volume from YouTube: \(v)")
                }
            } else if let error = error {
                print("Failed to get volume: \(error.localizedDescription)")
            }
        }
    }
    
    func increaseVolume(by delta: Double = 0.05) {
        getVolume()
        // async trigger
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let newVolume = min(self.volume + delta, 1.0)
            guard newVolume != self.volume else { return }
            self.setVolume(newVolume)
        }
    }

    func decreaseVolume(by delta: Double = 0.05) {
        getVolume()
        // async trigger
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let newVolume = max(self.volume - delta, 0.0)
            guard newVolume != self.volume else { return }
            self.setVolume(newVolume)
        }
        
    }
    
    func toggleMute() {
        if isMuted {
            // unmute to last persisted volume level
            setVolume(persistVolume)    // unmute
            isMuted = false
        } else {
            // persist current volume level and mute
            persistVolume = volume
            setVolume(0.0)      // mute
            isMuted = true
        }
    }
    
    /* --------------------------------------------------------------------------------- */

}
