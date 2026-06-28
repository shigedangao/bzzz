//
//  AppState.swift
//  bzzz
//
//  Created by Marc Intha on 28/06/2026.
//
import SwiftUI
import AppKit
import KeyboardShortcuts
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isMuted = false
    
    let micHandler = MicHandler()
    
    init() {
        isMuted = micHandler.getMutedFlag()
        
        KeyboardShortcuts.onKeyUp(for: .toggleMic) { [weak self] in
            Task { @MainActor in
               self?.toggleMic()
            }
        }
    }
    
    func toggleMic() {
        do {
            isMuted = try micHandler.toggleMuted()
        } catch {
            // set the michandler flag to 0 anyway
            micHandler.setMutedFlag(flag: 0)
            isMuted = micHandler.getMutedFlag()
        }
    }
    
    
}
