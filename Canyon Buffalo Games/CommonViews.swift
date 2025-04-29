import SwiftUI

struct CustomProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange)
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: 8)
            }
        }
    }
}

struct LoadingView: View {
    let progress: Double
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with gradient
               
                   
                
                Image("background_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                   
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0.6), .clear, .black.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Content
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
        .edgesIgnoringSafeArea(.all)
    }
}

struct NetworkErrorView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.fromHex("#141f2b"))
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Text("No internet connection")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Please check your connection and try again")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
    }
} 
