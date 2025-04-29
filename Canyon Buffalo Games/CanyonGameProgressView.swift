import Foundation
import SwiftUI

struct CanyonGameProgressView: View {
    let progress: Double
    
    var body: some View {
        LoadingView(progress: progress)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.8))
    }
}

#Preview {
    CanyonGameProgressView(progress: 0.5)
}

