//
//  PreviewView.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import Foundation
import AVKit

class PreviewView: UIView {
    
    private var captureSession: AVCaptureSession?
    private var shakeCountDown: Timer?
    let videoFileOutput = AVCaptureMovieFileOutput()
    var recordingDelegate: AVCaptureFileOutputRecordingDelegate!
    var recorded = 0
    var secondsToReachGoal = 20
    
    var onRecord: ((Int, Int) -> ())?
    var onReset: (() -> Void)?
    var onComplete: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        
        var allowedAccess = false
        let blocker = DispatchGroup()
        blocker.enter()
        
        AVCaptureDevice.requestAccess(for: .video) { flag in
            allowedAccess = flag
            blocker.leave()
        }
        blocker.wait()
        
        if !allowedAccess {
            print("NO ACCESS TO CAMERA")
            return
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
              session.canAddInput(videoDeviceInput) else {
                  print("NO CAMERA DETECTED")
                  return
        }
        session.addInput(videoDeviceInput)
        session.commitConfiguration()
        self.captureSession = session
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        recordingDelegate = self
        startTimers()
        if superview != nil {
            videoPreviewLayer.session = captureSession
            videoPreviewLayer.videoGravity = .resizeAspect
            captureSession?.startRunning()
            startRecording()
        } else {
            captureSession?.stopRunning()
        }
    }
    
    private func onTimerFires() {
        print("🟢 RECORDING \(videoFileOutput.isRecording)")
        secondsToReachGoal -= 1
        recorded += 1
        onRecord?(secondsToReachGoal, recorded)
        
        if(secondsToReachGoal == 0){
            stopRecording()
            shakeCountDown?.invalidate()
            shakeCountDown = nil
            onComplete?()
            videoFileOutput.stopRecording()
        }
    }
    
    func startTimers() {
        if shakeCountDown == nil {
            shakeCountDown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                self?.onTimerFires()
            }
        }
    }
    
    func startRecording() {
        captureSession?.addOutput(videoFileOutput)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent("tempPZDC")
        videoFileOutput.startRecording(to: filePath, recordingDelegate: recordingDelegate)
    }
    
    func stopRecording() {
        videoFileOutput.stopRecording()
        print("🔴 RECORDING \(videoFileOutput.isRecording)")
    }
}

extension PreviewView: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(outputFileURL.absoluteString)
    }
    
    
}
