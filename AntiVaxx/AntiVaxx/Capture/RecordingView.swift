//
//  RecordingView.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import SwiftUI
import Camera_SwiftUI
import AVFoundation
import Combine

struct RecordingView: View {
    
    @StateObject var cameraModel = CameraModel()
    
    @State var currentZoomFactor: CGFloat = 1.0
        
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    flashButton
                    CameraPreview(session: cameraModel.session)
                        .onAppear {
                            cameraModel.configure()
                        }
                        .alert(isPresented: $cameraModel.showAlertError, content: {
                            Alert(title: Text(cameraModel.alertError.title), message: Text(cameraModel.alertError.message), dismissButton: .default(Text(cameraModel.alertError.primaryButtonTitle), action: {
                                cameraModel.alertError.primaryAction?()
                            }))
                        })
                        .overlay(
                            Group {
                                if cameraModel.willCapturePhoto {
                                    Color.black
                                }
                            }
                        ).animation(.easeInOut)
                        
                    HStack {
                        capturePhotoThumbnail
                        Spacer()
                        captureButton
                        Spacer()
                        flipCameraButton
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    var captureButton: some View {
        Button {
            cameraModel.capturePhoto()
        } label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        }
    }
    
    var capturePhotoThumbnail: some View {
        Group {
            if cameraModel.photo != nil {
                Image(uiImage: cameraModel.photo.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .animation(.spring())
            } else {
                Image(systemName: "questionmark.video")
            }
        }
    }
    
    var flipCameraButton: some View {
        Button {
            cameraModel.flipCamera()
        } label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .foregroundColor(.white)
                )
        }
    }
    
    var flashButton: some View {
        Button {
            cameraModel.switchFlash()
        } label: {
            Image(systemName: cameraModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                .font(.system(size: 20, weight: .medium, design: .default))
        }
        .accentColor(cameraModel.isFlashOn ? .yellow : .white)
    }

}

#if DEBUG
struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
#endif
