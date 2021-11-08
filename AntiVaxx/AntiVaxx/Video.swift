//
//  Video.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import Foundation
import AVKit

struct Video: Identifiable, Equatable {
    
    var id: String
    var originalData: Data
    
    init(id: String = UUID().uuidString, originalData: Data) {
        self.id = id
        self.originalData = originalData
    }
    
    var videoAsset: AVAsset? {
        let tempVideoFile = TempVideoFile(withData: originalData)
        if let asset = tempVideoFile.avAsset {
            return asset
        }
        return nil
    }
}
