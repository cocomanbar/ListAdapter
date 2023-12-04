//
//  TableHeaderFooter.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/28.
//

import UIKit

open class TableHeaderFooter: NSObject {
    
    open var viewData: Any?
    open var viewHeight: CGFloat
    open var viewType: UITableViewHeaderFooterView.Type
    
    public init(viewType: UITableViewHeaderFooterView.Type, viewData: Any?, viewHeight: CGFloat) {
        self.viewType = viewType
        self.viewData = viewData
        self.viewHeight = viewHeight
    }
}
