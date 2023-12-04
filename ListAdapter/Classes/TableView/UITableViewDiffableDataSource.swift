//
//  UITableViewDiffableDataSource.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import UIKit

public extension UITableViewDiffableDataSource {
    
    func sectionIdentifier(with index: Int) -> SectionIdentifierType? {
        if #available(iOS 15.0, *) {
            return sectionIdentifier(for: index)
        } else {
            let sectionIdentifiers = snapshot().sectionIdentifiers
            if index < sectionIdentifiers.count {
                return sectionIdentifiers[index]
            }
            return nil
        }
    }
}
