import Foundation
import SwiftUI
import WebKit
import Foundation


enum GameLoadingState: Equatable {
    case idle
    case loading(progress: Double)
    case loaded
    case noInternet
    case failed(Error)
    
    static func == (lhs: GameLoadingState, rhs: GameLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading(let p1), .loading(let p2)):
            return p1 == p2
        case (.loaded, .loaded):
            return true
        case (.noInternet, .noInternet):
            return true
        case (.failed(let e1), .failed(let e2)):
            return e1.localizedDescription == e2.localizedDescription
        default:
            return false
        }
    }
}


extension Color {
    init?(hex: String) {
        
        let trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let cleanedHex = trimmedHex.hasPrefix("#") ? String(trimmedHex.dropFirst()) : trimmedHex
      
        guard cleanedHex.count == 3 || cleanedHex.count == 6 else {
            return nil
        }
        
        let finalHex: String
        if cleanedHex.count == 3 {
          
            finalHex = cleanedHex.map { String($0) + String($0) }.joined()
        } else {
         
            finalHex = cleanedHex
        }
        
      
        let scanner = Scanner(string: finalHex)
        var value: UInt32 = 0
        guard scanner.scanHexInt32(&value) else {
            return nil
        }
        
       
        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
