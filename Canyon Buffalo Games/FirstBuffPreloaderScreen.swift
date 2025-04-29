import Foundation
import Foundation
import SwiftUI



struct FirstBuffPreloaderScreen: View {
    @StateObject var buffViewModel: BuffViewModel
    
    init(buffViewmodel: BuffViewModel) {
        _buffViewModel = StateObject(wrappedValue: buffViewmodel)
    }
    
    var body: some View {
        ZStack {
            BufGameHolder(vm: buffViewModel)
            .opacity(buffViewModel.lstate == .loaded ? 1 : 0.5)
            if case .loading(let p) = buffViewModel.lstate {
                GeometryReader { geo in
                    BuffaloProgressState(progress: p)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(Color.black)
                }
            } else if case .failed(let e) = buffViewModel.lstate {
                Text("Error: \(e.localizedDescription)").foregroundColor(.red)
            } else if case .noInternet = buffViewModel.lstate {
                Text("")
            }
        }
    }
}
