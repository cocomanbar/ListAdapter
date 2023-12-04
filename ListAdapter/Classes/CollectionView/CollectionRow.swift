//
//  CollectionRow.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import UIKit

open class CollectionRow: ListDataRowable {
    
    public typealias CellType = UICollectionViewCell
    
    open var rowSize: CGSize
    open var rowData: ListIdentifiable
    open var rowReuseView: UICollectionViewCell?
    open var rowType: UICollectionViewCell.Type
    
    init(rowData: ListIdentifiable? = ListDataEmpty.default,
         rowType: UICollectionViewCell.Type = UICollectionViewCell.self,
         rowSize: CGSize = .zero) {
        self.rowData = rowData ?? ListDataEmpty.default
        self.rowType = rowType
        self.rowSize = rowSize
    }
}


extension CollectionRow: ListIdentifiable {
    
    public var listId: String {
        rowData.listId
    }
}


extension CollectionRow: Hashable, @unchecked Sendable {
    
    public static func == (lhs: CollectionRow, rhs: CollectionRow) -> Bool {
        lhs.rowData.listId == rhs.rowData.listId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rowData.listId)
    }
}
