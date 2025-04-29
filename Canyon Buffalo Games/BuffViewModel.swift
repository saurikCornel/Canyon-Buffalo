import Foundation
import SwiftUI
import WebKit

class BuffViewModel: ObservableObject {
    @Published var lstate: BuffLoaderResult = .idle
    let linkForLoader: URL
    private var buffaloScene: WKWebView?
    private var obsrvKey: NSKeyValueObservation?
    private var currentProgress: Double = 0.0
   
    
    init(url: URL) {
        self.linkForLoader = url
        
    }
    
    func setWebView(_ webView: WKWebView) {
        self.buffaloScene = webView
        observeLoading(webView)
        startLoadBuff()
       
    }
    
    func startLoadBuff() {
        guard let webView = buffaloScene else {
         
            return
        }
        let request = URLRequest(url: linkForLoader, timeoutInterval: 15.0)
      
       
        DispatchQueue.main.async { [weak self] in
            self?.lstate = .loading(progress: 0.0)
            self?.currentProgress = 0.0
        }
        webView.load(request)
    }
    
    private func observeLoading(_ webView: WKWebView) {
        obsrvKey = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            let progress = webView.estimatedProgress
           
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if progress > self.currentProgress {
                    self.currentProgress = progress
                    self.lstate = .loading(progress: self.currentProgress)
                }
                if progress >= 1.0 {
                    self.lstate = .loaded
                }
            }
        }
    }
    
    func updateNetworkStatus(_ isConnected: Bool) {
        if isConnected && lstate == .noInternet {
            startLoadBuff()
        } else if !isConnected {
            DispatchQueue.main.async { [weak self] in
                self?.lstate = .noInternet
            }
        }
       
    }
}
