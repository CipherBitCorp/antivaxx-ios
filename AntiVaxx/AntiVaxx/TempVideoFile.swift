//
//  TempVideoFile.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import Foundation
import AVFoundation

class TempVideoFile {
    var url: URL?
    
    init(withData: Data) {
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(UUID().uuidString).mov"
        let url = directory.appendingPathComponent(fileName)
        
        do {
            try withData.write(to: url)
        } catch {
            print("Error creating temp file: \(error)")
        }
    }
    
    var avAsset: AVAsset? {
        if let url = url {
            return AVAsset(url: url)
        }
        return nil
    }
    
    func deleteFile() {
        if let url = url {
            do {
                try FileManager.default.removeItem(at: url)
                self.url = nil
            } catch {
                print("Error deleting temp video file: \(error)")
            }
        }
    }
    
    deinit {
        deleteFile()
    }
}
