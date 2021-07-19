import Foundation
import SwiftUI
import MobileCoreServices

public struct FilePickerController: UIViewControllerRepresentable {
    public var callback: (URL) -> ()
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerController>) {
        // Update the controller
    }
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        print("Making the picker")
        let controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText)], in: .open)
        
        controller.delegate = context.coordinator
        print("Setup the delegate \(context.coordinator)")
        
        return controller
    }
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerController
        
        init(_ pickerController: FilePickerController) {
            self.parent = pickerController
            print("Setup a parent")
            print("Callback: \(String(describing: parent.callback))")
        }
       
        func documentPicker(didPickDocumentsAt: [URL]) {
            print("Selected a document: \(didPickDocumentsAt[0])")
            parent.callback(didPickDocumentsAt[0])
        }
        
        func documentPickerWasCancelled() {
            print("Document picker was thrown away :(")
        }
        
        deinit {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("START_SCHEDULERS"), object: nil)
            }
        }
    }
}

//
//  FilePickerView.swift
//  SilverEskimo
//
//  Created by Adam Dahan on 2021-04-21.
//  Copyright © 2021 MoneyClip. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct FilePickerView: View {
    var callback: (URL) -> ()
    var body: some View {
        FilePickerController(callback: callback)
    }
}
