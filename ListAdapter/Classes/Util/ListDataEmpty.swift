//
//  ListDataEmpty.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import Foundation

private var _ROWDATA_INCNUMBER_ID: Int64 = 0
private let queue = DispatchQueue(label: "com.listAdapter.data")

public class ListDataEmpty: ListIdentifiable {
    
    public var listId: String
    
    public init(listId: String) {
        self.listId = listId
    }
    
    public static var `default`: ListDataEmpty = {
        ROWDATA_INCNUMBER_ID += 1
        let listId = String(ROWDATA_INCNUMBER_ID)
        return ListDataEmpty(listId: listId)
    }()
}

public var ROWDATA_INCNUMBER_ID: Int64 {
    get {
        return queue.sync { _ROWDATA_INCNUMBER_ID }
    }
    set {
        queue.sync { _ROWDATA_INCNUMBER_ID = newValue }
    }
}
