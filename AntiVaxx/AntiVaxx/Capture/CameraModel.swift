//
//  RecordingViewModel.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import Foundation
import AVKit
import Combine
import Camera_SwiftUI

final class CameraModel: ObservableObject {
    private let cameraService = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = cameraService.session
        
        cameraService.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        cameraService.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.cameraService.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        cameraService.$flashMode.sink { [weak self] mode in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        cameraService.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        cameraService.checkForPermissions()
        cameraService.configure()
    }
    
    func capturePhoto() {
        cameraService.capturePhoto()
    }
    
    func flipCamera() {
        cameraService.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        cameraService.set(zoom: factor)
    }
    
    func switchFlash() {
        cameraService.flashMode = cameraService.flashMode == .on ? .off : .on
    }
}
