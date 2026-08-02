//
//  mic.swift
//  bzzz
//
//  Created by Marc Intha on 27/06/2026.
//
import CoreAudio

enum MicError: Error {
    case MicErrorMuted(OSStatus)
    case GainErrorMuted(OSStatus)
}

// MicHandler is a class which handle operation on the microphone
class MicHandler {
    var deviceId: AudioObjectID;
    var micSupported = false
    var mutePropAddr: AudioObjectPropertyAddress
    var scalarPropAddr: AudioObjectPropertyAddress
    
    init(deviceID: AudioObjectID) {
        self.deviceId = deviceID
        
        var size = UInt32(MemoryLayout<AudioObjectID>.size)
        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultInputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        // Get the property of the device in the deviceId pointer
        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &addr,
            0,
            nil,
            &size,
            &self.deviceId
        )
        
        // getting the property address of the mute
        self.mutePropAddr = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyMute,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        // get the scalar property address (volume scalar helps to turn from 0 to 1) a way to disable the mic as well.
        self.scalarPropAddr = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        // If so then set the miSupported flag to true.
        if AudioObjectHasProperty(self.deviceId, &self.mutePropAddr)  {
            self.micSupported = true
        }
    }
    
    // Toggle the microphone
    // 1. Either by using the mute property (depends if the device supports it)
    // 2. By controlling the gain...
    func toggleMuted(muted: Bool) throws {
        if self.micSupported {
            // mutedFlag is either a 1 or 0 as the API only support numerics values
            var mutedFlag = muted ? 0 : 1
            
            let status = AudioObjectSetPropertyData(self.deviceId, &self.mutePropAddr, 0, nil, UInt32(MemoryLayout<UInt32>.size), &mutedFlag)
            if status != 0 {
                throw MicError.MicErrorMuted(status)
            }
        }
        
        
        var gainedFlag = muted ? 0.0 : 1.0
        let status = AudioObjectSetPropertyData(self.deviceId, &self.scalarPropAddr, 0, nil, UInt32(MemoryLayout<Float32>.size), &gainedFlag)
        if status != 0 {
            throw MicError.GainErrorMuted(status)
        }
    }
}
