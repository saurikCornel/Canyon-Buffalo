import Foundation
import WebKit

class CanyonGameController: NSObject, WKNavigationDelegate {
    private let container: CanyonGameContainer
    
    init(container: CanyonGameContainer) {
        self.container = container
        super.init()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Allow initial load
        if navigationAction.request.url == container.stateManager.gameSourceURL {
            decisionHandler(.allow)
            return
        }
        
        // Handle external links
        if navigationAction.navigationType == .linkActivated,
           let url = navigationAction.request.url,
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        
        // Allow same-origin navigation
        if let requestHost = navigationAction.request.url?.host,
           let sourceHost = container.stateManager.gameSourceURL.host,
           requestHost == sourceHost {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }
    
    private func handleError(_ error: Error) {
        debugPrint("Navigation error: \(error.localizedDescription)")
        
        // Check if it's a network error
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorCannotConnectToHost:
                container.stateManager.handleNetworkStatusChange(false)
            default:
                break
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Inject any required JavaScript here if needed
        container.stateManager.handleNetworkStatusChange(true)
    }
}
