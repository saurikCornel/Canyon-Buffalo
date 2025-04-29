import Foundation
import SwiftUI
import WebKit

struct BufGameHolder: UIViewRepresentable {
    @ObservedObject var vm: BuffViewModel
    
    func makeCoordinator() -> BuffController {
        BuffController(owner: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let view = WKWebView(frame: .zero, configuration: config)
        
        
        view.backgroundColor = UIColor(hex: "#141f2b")
        view.isOpaque = false
       
        let dataTypes = Set([WKWebsiteDataTypeDiskCache,
                           WKWebsiteDataTypeMemoryCache,
                           WKWebsiteDataTypeCookies,
                           WKWebsiteDataTypeLocalStorage])
        
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes,
                                              modifiedSince: Date.distantPast) {
           
        }
        
        debugPrint("Renderer: \(vm.linkForLoader)")
        view.navigationDelegate = context.coordinator
        vm.setWebView(view)
        return view
    }
    
    func updateUIView(_ view: WKWebView, context: Context) {
        let dataTypes = Set([WKWebsiteDataTypeDiskCache,
                           WKWebsiteDataTypeMemoryCache,
                           WKWebsiteDataTypeCookies,
                           WKWebsiteDataTypeLocalStorage])
        
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes,
                                              modifiedSince: Date.distantPast) {
            
        }
        
    }
}

