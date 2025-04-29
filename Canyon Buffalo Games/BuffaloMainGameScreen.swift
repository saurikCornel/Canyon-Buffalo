import Foundation

import SwiftUI

struct BuffaloMainGameScreen: View {
    let url: URL = .init(string: "https://canynbufgaes.run/start/")!
    var body: some View {
        FirstBuffPreloaderScreen(buffViewmodel: .init(url: url))
            .background(Color(hex: "5F3235").ignoresSafeArea())
    }
}




extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}





#Preview {
    BuffaloMainGameScreen()
}
