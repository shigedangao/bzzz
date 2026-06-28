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
            Spacer()
            HStack {
                Image(systemName: "microphone.circle.fill")
                    .symbolRenderingMode(.monochrome)
                    .symbolVariant(.none)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                Spacer()
                Toggle("Muted", isOn: Binding(
                    get: {
                        appState.isMuted
                    },
                    set: { _ in
                        appState.toggleMic()
                    }
                )).toggleStyle(.switch)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20.0)
            
            VStack(alignment: .leading) {
                Text("Set any shortcut to toggle mic")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                KeyboardShortcuts.Recorder("Shortcut", name: .toggleMic)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .cornerRadius(10.0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding([.top, .bottom], 15)
        .padding([.leading, .trailing], 5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    @Previewable @State var appState: AppState = AppState()
    
    ContentView(appState: appState)
}
