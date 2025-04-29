import Foundation

import SwiftUI


struct BuffaloProgressState: View {
    var progress: Double
 
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    Image(.buffaloImg)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.8)
                }
                .ignoresSafeArea()
                
                VStack {
                        Text("The game is loading: \(Int(progress * 100))%")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    Spacer()
                }
            }
            .frame(width: geometry.size.width)
            .background(
                Image(.background)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.black, .clear, .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                           
                        )
            )
        }
    }
}

#Preview {
    BuffaloProgressState(progress: 0.2)
}

