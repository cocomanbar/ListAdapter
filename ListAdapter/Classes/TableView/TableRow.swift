//
//  TableRow.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import UIKit

open class TableRow: ListDataRowable {
    
    public typealias CellType = UITableViewCell
    
    open var rowHeight: CGFloat = 44
    open var rowData: ListIdentifiable
    open var rowType: UITableViewCell.Type
    open var rowReuseView: UITableViewCell?
    
    public init(rowData: ListIdentifiable? = ListDataEmpty.default,
                rowType: UITableViewCell.Type = UITableViewCell.self,
                rowHeight: CGFloat = 44) {
        self.rowData = rowData ?? ListDataEmpty.default
        self.rowType = rowType
        self.rowHeight = rowHeight
    }
}


extension TableRow: ListIdentifiable {
    
    public var listId: String {
        rowData.listId
    }
}


extension TableRow: Hashable, @unchecked Sendable {
    
    public static func == (lhs: TableRow, rhs: TableRow) -> Bool {
        lhs.rowData.listId == rhs.rowData.listId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rowData.listId)
    }
}
