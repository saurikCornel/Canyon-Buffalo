import Foundation
import SwiftUI

struct CanyonGamePreloader: View {
    @StateObject private var stateManager: CanyonGameStateManager
    @State private var isNetworkAvailable = true
    
    init(url: URL) {
        _stateManager = StateObject(wrappedValue: CanyonGameStateManager(url: url))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#5F3235")
                .ignoresSafeArea()
            
            VStack {
                if case .loading(let progress) = stateManager.loadingState {
                    LoadingView(progress: progress)
                } else if case .noInternet = stateManager.loadingState {
                    NetworkErrorView()
                } else {
                    CanyonGameContainer(stateManager: stateManager)
                }
            }
        }
        .onAppear {
            setupNetworkMonitoring()
        }
    }
    
    private func setupNetworkMonitoring() {
        // Network monitoring logic here
    }
} 
