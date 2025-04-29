import Foundation
import SwiftUI
import WebKit

struct CanyonGameContainer: UIViewRepresentable {
    @StateObject var stateManager: CanyonGameStateManager
    
    func makeCoordinator() -> CanyonGameController {
        CanyonGameController(container: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Return existing WebView from state manager
        guard let webView = stateManager.webView else {
            fatalError("WebView should be created in CanyonGameStateManager")
        }
        return webView
    }
    
    func updateUIView(_ view: WKWebView, context: Context) {
        // Do nothing to prevent reloading
    }
} 