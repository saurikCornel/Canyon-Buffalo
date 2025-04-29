enum LoadingState: Equatable {
    case idle
    case loading(progress: Double)
    case loaded
    case noInternet
    case failed(Error)
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
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