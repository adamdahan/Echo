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
    
    // MARK: - Singleton
    
    public static let main = Echo()
    
    // MARK: - Internal Providers
    
    private let fileProvider = File.main
    private let logProvider = Logger.main
    private let storageProvider = StorageProvider.main
    
    // MARK: - Observing
        
    @ObservedObject public var carrierDelegate = Delegate()

    // MARK: - Lazily loaded
    
    private lazy var floatingButton: FloatingView = {
        let normalButton:UIButton = UIButton(type: UIButton.ButtonType.system)
        normalButton.backgroundColor = .red
        normalButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        normalButton.layer.cornerRadius = 50
        normalButton.addTarget(self, action: #selector(Echo.show), for: .touchUpInside)
        var floatingView = FloatingView(with: normalButton)
        floatingView.delegate = self
        return floatingView
    }()
    
    // MARK: - Class methods
        
    public class func start() {
        
        /// Setup the http injector
                
        Echo.main.setupEchoHTTP()
        
        /// Setup the Echo logs directory
        
        Echo.main.fileProvider.bootstrap()
    }
    
    // MARK: - Showing Echo
    
    // Show Echo on top of any view controller that sits in the key window's root
    //
    
    @objc public class func show() {
    
        /// Get the keywindow from the connectedScenes whose activation state is in the foreground
        
        guard
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first,
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
    
    public class func showBubble() {
        Echo.main.floatingButton.show()
    }

    // MARK: - Private Setup
    
    private func setupEchoHTTP() {
        let configuration = BagelConfiguration()
        configuration.carrierDelegate = Echo.main.carrierDelegate;
        Bagel.start(configuration)
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
