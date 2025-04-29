import SwiftUI

struct GameLoadingView: View {
    @ObservedObject var gameStateManager: CanyonGameStateManager
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with gradient
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                Image("background_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0.6), .clear, .black.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Content based on loading state
                switch gameStateManager.loadingState {
                case .idle:
                    loadingContent(progress: 0, geometry: geometry)
                    
                case .loading(let progress):
                    loadingContent(progress: progress, geometry: geometry)
                    
                case .noInternet:
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("No Internet Connection")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Please check your connection and try again")
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            gameStateManager.initializeLoading()
                        }) {
                            Text("Retry")
                                .foregroundColor(.black)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                    
                case .loaded:
                    EmptyView()
                    
                case .failed(let error):
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        
                        Text("Error")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text(error.localizedDescription)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            gameStateManager.initializeLoading()
                        }) {
                            Text("Retry")
                                .foregroundColor(.black)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func loadingContent(progress: Double, geometry: GeometryProxy) -> some View {
        if verticalSizeClass == .regular {
            // Portrait layout
            VStack {
                Spacer()
                    .frame(height: geometry.size.height * 0.2)
                
                // Logo
                Image("buffalo_img")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: min(geometry.size.width * 0.5, 200))
                
                Spacer()
                
                // Progress
                VStack(spacing: 15) {
                    Text("Loading game... \(Int(progress * 100))%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Progress bar
                    CustomProgressBar(progress: progress)
                        .frame(height: 8)
                        .frame(width: min(geometry.size.width * 0.7, 280))
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
            }
        } else {
            // Landscape layout
            HStack(spacing: 30) {
                // Logo
                Image("buffalo_img")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: min(geometry.size.height * 0.4, 150))
                
                // Progress
                VStack(spacing: 15) {
                    Text("Loading game... \(Int(progress * 100))%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Progress bar
                    CustomProgressBar(progress: progress)
                        .frame(height: 8)
                        .frame(width: min(geometry.size.width * 0.4, 280))
                }
            }
            .padding(.horizontal, 40)
        }
    }
}