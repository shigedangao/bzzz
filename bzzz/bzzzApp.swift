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
    
    private var menuIcon: Image {
        let name = appState.isMuted ? "microphone.slash.circle.fill" : "microphone.circle.fill"
        let colorConfig = NSImage.SymbolConfiguration(hierarchicalColor: appState.isMuted ? .systemRed : .systemBlue)
        let sizeConfig = NSImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            .applying(colorConfig)
        
        let img = NSImage(systemSymbolName: name, accessibilityDescription: nil)!.withSymbolConfiguration(sizeConfig)!
        img.isTemplate = false
        
        return Image(nsImage: img)
    }
    
    var body: some Scene {
        MenuBarExtra{
            ContentView(appState: appState)
                .frame(width: 250, height: 150)

        } label: {
            menuIcon
        }
        .menuBarExtraStyle(.window)
    }
}
