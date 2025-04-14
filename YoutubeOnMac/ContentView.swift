//
//  ContentView.swift
//  YoutubeOnMac
//
//  Created by Ritwik Babu on 4/13/25.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    let youtubeURL = URL(string: "https://www.youtube.com")!
    @StateObject private var webViewModel = WebViewStateModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Menu Bar
            HStack {
                Button(action: { webViewModel.goBack() }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }.padding(.horizontal, 12)
                
                Button(action: { webViewModel.goForward() }) {
                    HStack {
                        Text("Forward")
                            .font(.system(size: 14, weight: .semibold))
                        Image(systemName: "chevron.forward")
                    }
                }
                Spacer()
                Button(action: { webViewModel.reload() }) {
                    HStack {
                        Text("Refresh")
                            .font(.system(size: 14, weight: .semibold))
                        Image(systemName: "arrow.clockwise")
                    }
                }.padding(.trailing, 12)
            }
            .padding(8)
            .background(Color(NSColor.windowBackgroundColor))
            .frame(height: 40)
            
            Divider()
            
            WebView(url: youtubeURL, stateModel: webViewModel)
                .frame(minWidth: 800, minHeight: 600)
        }
    }
}

#Preview {
    ContentView()
}
