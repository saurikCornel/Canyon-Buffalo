//
//  Canyon_Buffalo_GamesApp.swift
//  Canyon Buffalo Games
//
//  Created by alex on 4/29/25.
//

import SwiftUI

@main
struct CanyonBuffaloGamesApp: App {
    var body: some Scene {
        WindowGroup {
            CanyonGameScreen(url: URL(string: "https://canynbufgaes.run/start/")!)
        }
    }
}
