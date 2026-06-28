//
//  ContentView.swift
//  bzzz
//
//  Created by Marc Intha on 27/06/2026.
//

import SwiftUI
import KeyboardShortcuts

struct ContentView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "microphone.circle.fill")
                    .symbolRenderingMode(.monochrome)
                    .symbolVariant(.none)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                Toggle("Muted", isOn: Binding(
                    get: {
                        appState.isMuted
                    },
                    set: { _ in
                        appState.toggleMic()
                    }
                )).toggleStyle(.switch)
            }
            
            KeyboardShortcuts.Recorder("shortcut", name: .toggleMic)
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var appState: AppState = AppState()
    
    ContentView(appState: appState)
}
