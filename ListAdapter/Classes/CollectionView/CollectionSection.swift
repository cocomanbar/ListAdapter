//
//  CollectionSection.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import Foundation

open class CollectionSection {

    open var listId: String
    open var header: CollectionHeaderFooter?
    open var footer: CollectionHeaderFooter?
    
    public init(listId: String, header: CollectionHeaderFooter? = nil, footer: CollectionHeaderFooter? = nil) {
        self.listId = listId
        self.header = header
        self.footer = footer
    }
}

extension CollectionSection: Hashable, @unchecked Sendable {
    
    public static func == (lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        lhs.listId == rhs.listId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(listId)
    }
}

extension CollectionSection: ListIdentifiable { }
