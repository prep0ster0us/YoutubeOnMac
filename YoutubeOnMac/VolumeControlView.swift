import SwiftUI

struct VolumeControlView: View {
    @ObservedObject var webViewModel: WebViewStateModel
    let minSliderLength: CGFloat = 50
    let maxSliderLength: CGFloat = 250
    
    init(_ webViewModel: WebViewStateModel) {
        self.webViewModel = webViewModel
    }

    var body: some View {
        HStack(spacing: 8) {
            // Decrease volume
            Button {
                webViewModel.decreaseVolume()
            } label: {
                Image(systemName: "speaker.fill")
            }

            // Volume Slider
            Slider (
                value: $webViewModel.volume,
                in: 0...1
//                step: 0.05
            )
            .frame(minWidth: minSliderLength, maxWidth: maxSliderLength)
                .onChange(of: webViewModel.volume) { _, newValue in
                    webViewModel.setVolume(newValue)
                }

            // Increase volume
            Button {
                webViewModel.increaseVolume()
            } label: {
                Image(systemName: "speaker.wave.3.fill")
            }

            // Mute button
            Button {
                webViewModel.toggleMute()
            } label: {
                Image(systemName: "speaker.slash.fill")
                    .foregroundStyle(webViewModel.isMuted ? .blue : .white)
            }
            .animation(.easeInOut(duration: 0.2), value: webViewModel.isMuted)

        }
        .padding(.horizontal, 8)
    }
}


#Preview {
    VolumeControlView(WebViewStateModel())
}
