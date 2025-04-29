import Foundation
import WebKit

class BuffController: NSObject, WKNavigationDelegate {
    let holder: BufGameHolder
    var buffFlag = false
  
    init(owner: BufGameHolder) {
        self.holder = owner
    }
    
    private func updateState(_ state: BuffLoaderResult) {
        DispatchQueue.main.async { [weak self] in
            self?.holder.vm.lstate = state
        }
    }
    
    func webView(_ wv: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if !buffFlag { updateState(.loading(progress: 0.0)) }
    }
    
    func webView(_ wv: WKWebView, didCommit _: WKNavigation!) {
        buffFlag = false
    }
    
    func webView(_ wv: WKWebView, didFinish _: WKNavigation!) {
       
        updateState(.loaded)
    }
    
    func webView(_ wv: WKWebView, didFail _: WKNavigation!, withError e: Error) {
        updateState(.failed(e))
    }
    
    func webView(_ wv: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError e: Error) {
        updateState(.failed(e))
    }
    
    func webView(_ wv: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if action.navigationType == .other && wv.url != nil {
            buffFlag = true
        }
        decisionHandler(.allow)
    }
}
