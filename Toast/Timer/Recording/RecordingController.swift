//
//  RecodingController.swift
//  Toast
//
//  Created by ParkSungJoon on 06/07/2019.
//  Copyright © 2019 DDD. All rights reserved.
//

import Foundation
import AVFoundation

class RecordingController {
    
    var recordingSession: AVAudioSession
    var audioRecorder: AVAudioRecorder?
    
    init(recordingSession: AVAudioSession = AVAudioSession.sharedInstance()) {
        self.recordingSession = recordingSession
    }
    
    func start() {
        let audioFilename = getDocumentDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder.delegate = self
            audioRecorder?.record()
        } catch {
            // Recording Fail
        }
    }
    
    func finish() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
}

private extension RecordingController {
    
    func setupRecordingSession() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission { (allowed) in
                if allowed {
                    
                }
            }
        } catch {
            
        }
    }
    
    func getDocumentDirectory() -> URL {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        return path
    }
}
