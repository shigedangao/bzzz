//
//  listener.swift
//  bzzz
//
//  Created by Marc Intha on 02/08/2026.
//
import CoreAudio

// MicDeviceListener is a class which listen to the list of audio devices available
// Most of the implementation is based on the following article below
// @link https://medium.com/@itsuki.enjoy/swift-macos-listen-for-input-device-changes-three-ways-6b60e5367aa0
class MicDeviceListener {
    // Reference of the list of devices available
    private var listenerBlock: AudioObjectPropertyListenerBlock?
    
    private var devicesAddr = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    
    // Initialize the audio listener
    // Whenever an update is found:
    // - Get the list of devices available
    // - Returns the list of devices ID (AudioObjectID) via the onUpate callback
    init(onUpdate: @escaping ([AudioObjectID]) -> Void) {
        let block: AudioObjectPropertyListenerBlock = { [weak self] _, _ in
            guard let self else { return }
            
            onUpdate(self.getDevicesIDs())
        }
        
        AudioObjectAddPropertyListenerBlock(
            AudioObjectID(kAudioObjectSystemObject),
            &devicesAddr,
            DispatchQueue.main,
            block
        )
    }
    
    func getDevicesIDs() -> [AudioObjectID] {
        let objects = AudioObjectID(kAudioObjectSystemObject)
        var size: UInt32 = 0
        
        var status = AudioObjectGetPropertyDataSize(
            objects,
            &devicesAddr,
            0,
            nil,
            &size
        )
        
        guard status == noErr else {
            print("failed to get device-list size", status)
            
            return []
        }
        
        let deviceCount = Int(size) / MemoryLayout<AudioObjectID>.size
        var deviceIDs = [AudioObjectID](
            repeating: 0, count: deviceCount
        )
        
        status = deviceIDs.withUnsafeMutableBufferPointer { buffer in
            AudioObjectGetPropertyData(
                objects,
                &devicesAddr,
                0,
                nil,
                &size,
                buffer.baseAddress!
            )
        }
        
        guard status == noErr else {
            print("Failed to get device IDs:", status)
            
            return []
        }
        
        return deviceIDs
    }
    
    deinit {
        if let block = self.listenerBlock {
            // Remove the device from the listener block
            var address = AudioObjectPropertyAddress(
                mSelector: kAudioHardwarePropertyDevices,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain
            )
            
            AudioObjectRemovePropertyListenerBlock(
                AudioObjectID(kAudioObjectSystemObject),
                &address,
                DispatchQueue.main,
                block
            )
        }
    }
}
