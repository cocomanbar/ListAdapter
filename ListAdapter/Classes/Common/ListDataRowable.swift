//
//  ListDataRowable.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import Foundation

public protocol ListDataRowable {
    
    associatedtype CellType
    
    var rowData: ListIdentifiable { get set }
    var rowType: CellType.Type { get set }
    var rowReuseView: CellType? { get set }
}
