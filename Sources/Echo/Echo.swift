//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-04.
//

import UIKit
import SwiftUI
import EchoHTTP

@available(iOS 14.0, *)
public class Echo: ObservableObject {
    
    public var disableInRelease: Bool = true
    
    // MARK: - Singleton
    
    public static let main = Echo()
    
    // MARK: - Internal Providers
    
    private let fileProvider = File.main
    private let logProvider = Logger.main
    private let storageProvider = StorageProvider.main
    
    // MARK: - Observing
        
    @ObservedObject public var atlantisDelegate = EchoAtlantisDelegate()

    // MARK: - Class methods
        
    public class func start() {
        
        if Echo.main.disableInRelease {
            return
        }
        
        /// Setup the http injector
                
        Echo.main.setupEchoHTTP()
        
        /// Setup the Echo logs directory
        
        Echo.main.fileProvider.bootstrap()
    }
    
    // MARK: - Showing Echo
    
    // Show Echo on top of any view controller that sits in the key window's root
    //
    
    @objc public class func show() {
        
        if Echo.main.disableInRelease {
            return
        }
    
        /// Get the keywindow from the connectedScenes whose activation state is in the foreground
        
        guard
            let keyWindow = UIApplication.keyWindow,
            let rootViewController = keyWindow.rootViewController
        else {
            return
        }
        
        /// Get the top most view controller from the root
        /// present on that
        
        let topMostController = rootViewController.topMostViewController()
        topMostController.present(
            UIHostingController(rootView: MainView()
        ),
            animated: true,
            completion: nil
        )
    }
    
    public class func showBanner() {
        
        if Echo.main.disableInRelease {
            return
        }
        
        let image = EchoImage(named: "spy")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        
        let button = ShadowButton(frame: CGRect(x: 20, y: 60, width: 60, height: 60))
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tag = 19880901
        
        button.addTarget(self, action: #selector(show), for: .touchUpInside)
        UIApplication.keyWindow?.rootViewController?.view.addSubview(button)
    }

    // MARK: - Private Setup
    
    private func setupEchoHTTP() {
        
        if Echo.main.disableInRelease {
            return
        }
        
        Atlantis.start()
        Atlantis.setDelegate(Echo.main.atlantisDelegate)
    }
}

// MARK: - Floating Bubble Delegate

@available(iOS 14.0, *)
extension Echo: FloatingViewDelegate {
    
    public func viewDraggingDidBegin(view: UIView, in window: UIWindow?) {
        
    }
    
    public func viewDraggingDidEnd(view: UIView, in window: UIWindow?) {
        
    }
}
