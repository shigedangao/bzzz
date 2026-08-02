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
import CoreAudio

@MainActor
final class AppState: ObservableObject {
    @Published var isMuted = false
    @Published var devices: [AudioObjectID: MicHandler] = [:]
    
    // Use an optional
    private var micListener: MicDeviceListener?
    
    init() {
        // Use weak self in case if the lifetime of the closure is greater than self
        micListener = MicDeviceListener { [weak self] devices in
            Task { @MainActor [weak self] in
                for deviceID in devices {
                    self?.devices[deviceID] = MicHandler(deviceID: deviceID)
                }
            }
        }
        
        // Update the list of devices when micListener is Some
        if let handler = micListener {
            let initialDevices = handler.getDevicesIDs()
            for deviceID in initialDevices {
                self.devices[deviceID] = MicHandler(deviceID: deviceID)
            }
        }
        
        // At init stage, set the mic to unmuted (make sure that we start from a clean sheet).
        self.toggleMic(isMuted: false)
        self.isMuted = false
        
        KeyboardShortcuts.onKeyUp(for: .toggleMic) { [weak self] in
            Task { @MainActor in
                self?.toggleMic(isMuted: self!.isMuted)
            }
        }
    }
    
    func toggleMic(isMuted: Bool) {
        for (_, handler) in self.devices {
            do {
                // We try to set the muted toggle for each registered devices
                try handler.toggleMuted(muted: isMuted)
            } catch {
                print("Unable to toggle microphone of the desired device")
            }
        }
        
        self.isMuted = !isMuted
    }
}
