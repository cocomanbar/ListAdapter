//
//  EventRouter.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/3.
//

import UIKit

@objc public protocol ListEvent {
    
    func router(_ event: String, with paramter: Any?)
}

extension UIResponder: ListEvent {
    
    // transmission event through the response chain simply.
    open func router(_ event: String, with paramter: Any?) {
        next?.router(event, with: paramter)
    }
}


