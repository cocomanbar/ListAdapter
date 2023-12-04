//
//  UICollectionViewDiffableDataSource.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import UIKit

extension UICollectionViewDiffableDataSource {
    
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
