//
//  VideoRecordingView.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import Foundation
import SwiftUI

struct VideoRecordingView: UIViewRepresentable {
    
    @Binding var timeLeft: Int
    @Binding var onComplete: Bool
    @Binding var recording: Bool

    func makeUIView(context: UIViewRepresentableContext<VideoRecordingView>) -> some UIView {
        let previewView = PreviewView()
        previewView.onComplete = {
            self.onComplete = true
        }
        
        previewView.onRecord = { timeLeft, totalShakes in
            self.timeLeft = timeLeft
            self.recording = true
        }
        
        previewView.onReset = {
            self.recording = false
            self.timeLeft = 30
        }
        
        return previewView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func startRecording() {
        
    }
    
}
