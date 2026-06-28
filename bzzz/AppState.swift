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
        isMuted = micHandler.get_muted_flag()
        
        KeyboardShortcuts.onKeyUp(for: .toggleMic) { [weak self] in
            Task { @MainActor in
               self?.toggleMic()
            }
        }
    }
    
    func toggleMic() {
        print("enter here")
        do {
            try micHandler.toggle_muted()
            isMuted = micHandler.get_muted_flag()
        } catch {
            // set the michandler flag to 0 anyway
            micHandler.set_muted_flag(flag: 0)
            isMuted = micHandler.get_muted_flag()
        }
    }
    
    
}
