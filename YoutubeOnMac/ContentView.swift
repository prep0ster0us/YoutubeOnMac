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
    
    var body: some View {
        WebView(url: youtubeURL)
                    .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    ContentView()
}
