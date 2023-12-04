//
//  TableSection.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import Foundation

open class TableSection {

    open var listId: String
    open var header: TableHeaderFooter?
    open var footer: TableHeaderFooter?
    
    public init(listId: String, header: TableHeaderFooter? = nil, footer: TableHeaderFooter? = nil) {
        self.listId = listId
        self.header = header
        self.footer = footer
    }
}

extension TableSection: Hashable, @unchecked Sendable {
    
    public static func == (lhs: TableSection, rhs: TableSection) -> Bool {
        lhs.listId == rhs.listId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(listId)
    }
}

extension TableSection: ListIdentifiable { }
