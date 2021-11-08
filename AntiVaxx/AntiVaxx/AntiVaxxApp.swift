//
//  AntiVaxxApp.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import SwiftUI
import Firebase

@main
struct AntiVaxxApp: App {
    
    init() {
        FirebaseApp.configure()
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        let imagesRef = storageRef.child("images")
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
