//
//  CollectionHeaderFooter.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import UIKit

open class CollectionHeaderFooter: NSObject {
    
    open var viewData: Any?
    open var viewHeight: CGFloat
    open var viewType: UICollectionReusableView.Type
    
    public init(viewType: UICollectionReusableView.Type, viewData: Any?, viewHeight: CGFloat) {
        self.viewType = viewType
        self.viewData = viewData
        self.viewHeight = viewHeight
    }
}
