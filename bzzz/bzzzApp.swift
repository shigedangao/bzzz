//
//  bzzzApp.swift
//  bzzz
//
//  Created by Marc Intha on 27/06/2026.
//

import SwiftUI

@main
struct bzzzApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        
        MenuBarExtra(
            "bzz",
            systemImage: appState.isMuted ? "mic.slash.fill" : "microphone.circle.fill"
        ) {
            ContentView(appState: appState)
                .frame(width: 200, height: 100)

        }
        .menuBarExtraStyle(.window)
    }
}
