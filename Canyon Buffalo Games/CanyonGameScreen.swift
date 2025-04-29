import Foundation
import SwiftUI

struct CanyonGameScreen: View {
    @StateObject private var stateManager: CanyonGameStateManager
    
    init(url: URL) {
        _stateManager = StateObject(wrappedValue: CanyonGameStateManager(url: url))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#5F3235")
                .ignoresSafeArea()
            CanyonGameContainer(stateManager: stateManager)
                .opacity(stateManager.loadingState == .loaded ? 1 : 0)
                
            
            switch stateManager.loadingState {
            case .idle:
                GameLoadingView(gameStateManager: stateManager)
                    .ignoresSafeArea()
            case .loading:
                GameLoadingView(gameStateManager: stateManager)
                    .ignoresSafeArea()
            case .loaded:
                EmptyView()
            case .noInternet:
                GameLoadingView(gameStateManager: stateManager)
                    .ignoresSafeArea()
            case .failed(let error):
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    let gameURL = URL(string: "https://canynbufgaes.run/start")!
    return CanyonGameScreen(url: gameURL)
} 
