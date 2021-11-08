//
//  ContentView.swift
//  AntiVaxx
//
//  Created by Kaan Ersan on 2021-11-06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            RecordingView()
                .tabItem {
                    Image(systemName: "video")
                    Text("Capture")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
