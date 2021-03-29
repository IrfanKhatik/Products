//
//  OrientationListner.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 28/03/21.
//

import Foundation
import UIKit

protocol OrientationListnerProtocol  {
    var identifier: String { get set }
    func isEqualTo(_ other: OrientationListnerProtocol) -> Bool
    func orientationChanged()
}

extension OrientationListnerProtocol where Self: Equatable {
    func isEqualTo(_ other: OrientationListnerProtocol) -> Bool {
        guard let otherlistner = other as? Self else { return false }
        return self == otherlistner
    }
}

class OrientationListner {
    
    // Singleton OrientationListner
    static let shared = OrientationListner()
    
    // List of all View who are currently on app window.
    var listners : [OrientationListnerProtocol] = []
    
    private init() {
        // Listen device orientation change.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanges(_:)),
                                               name:UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    func find(value listner: OrientationListnerProtocol) -> Int? {
        for (index, value) in listners.enumerated()
        {
            if value.isEqualTo(listner)  {
                return index
            }
        }
        
        return nil
    }
    
    // Notify current screen View about orientation change
    @objc func orientationChanges(_ notification:Notification) {
        guard let listner = listners.last else {
            return
        }
        
        listner.orientationChanged()
    }
    
}
