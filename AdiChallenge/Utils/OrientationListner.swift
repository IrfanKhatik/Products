//
//  OrientationListner.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 28/03/21.
//

import Foundation
import UIKit

protocol OrientationListnerProtocol {
    func orientationChanged()
}

class OrientationListner {
    
    static let shared = OrientationListner()
    
    var listners : [OrientationListnerProtocol] = []
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanges(_:)),
                                               name:UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    @objc func orientationChanges(_ notification:Notification) {
        guard let listner = listners.last else {
            return
        }
        
        listner.orientationChanged()
    }
    
}
