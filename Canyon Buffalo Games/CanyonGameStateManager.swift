import Foundation
import SwiftUI
import WebKit

class CanyonGameStateManager: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var loadingState: LoadingState = .idle
    let gameSourceURL: URL
    private(set) var webView: WKWebView?
    private var observation: NSKeyValueObservation?
    private var currentProgress: Double = 0.0
    
    init(url: URL) {
        self.gameSourceURL = url
        super.init()
        setupWebView()
    }
    
    private func setupWebView() {
        // Configure WKWebView
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        // Create and configure WKWebView
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = UIColor.fromHex("#5F3235")
        webView.isOpaque = false
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = self
        
        self.webView = webView
        observeLoading(webView)
        
        // Clear cache and cookies
        let dataTypes = Set([
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeSessionStorage,
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeIndexedDBDatabases,
            WKWebsiteDataTypeWebSQLDatabases
        ])
        
        WKWebsiteDataStore.default().removeData(
            ofTypes: dataTypes,
            modifiedSince: Date(timeIntervalSince1970: 0)
        ) { [weak self] in
            self?.startLoading()
        }
    }
    
    private func observeLoading(_ webView: WKWebView) {
        observation?.invalidate()
        
        observation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            let progress = webView.estimatedProgress
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if progress > self.currentProgress {
                    self.currentProgress = progress
                    self.loadingState = .loading(progress: self.currentProgress)
                }
                if progress >= 1.0 {
                    self.loadingState = .loaded
                }
            }
        }
    }
    
    func startLoading() {
        guard let webView = webView, loadingState != .loading(progress: currentProgress) else {
            return
        }
        
        let request = URLRequest(url: gameSourceURL, timeoutInterval: 15.0)
        
        DispatchQueue.main.async { [weak self] in
            self?.loadingState = .loading(progress: 0.0)
            self?.currentProgress = 0.0
        }
        
        webView.load(request)
    }
    
    func initializeLoading() {
        startLoading()
    }
    
    func handleNetworkStatusChange(_ isConnected: Bool) {
        if isConnected && loadingState == .noInternet {
            startLoading()
        } else if !isConnected {
            DispatchQueue.main.async { [weak self] in
                self?.loadingState = .noInternet
            }
        }
    }
    
    deinit {
        observation?.invalidate()
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingState = .loaded
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async { [weak self] in
            if (error as NSError).code == -1009 { // No internet connection
                self?.loadingState = .noInternet
            } else {
                self?.loadingState = .failed(error)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async { [weak self] in
            if (error as NSError).code == -1009 { // No internet connection
                self?.loadingState = .noInternet
            } else {
                self?.loadingState = .failed(error)
            }
        }
    }
}
