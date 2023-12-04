//
//  CollectionView.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import UIKit

public extension UICollectionView {
    
    func register<Cell: UICollectionViewCell>(with cellType: Cell.Type) {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func register<View: UICollectionReusableView>(with supplementaryViewType: View.Type, forSupplementaryViewOfKind elementKind: String) {
        register(supplementaryViewType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: supplementaryViewType.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(with cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier).")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<View: UICollectionReusableView>(with supplementaryViewType: View.Type,ofKind elementKind: String, for indexPath: IndexPath) -> View {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: supplementaryViewType.reuseIdentifier, for: indexPath) as? View else {
            fatalError("Failed to dequeue a view with identifier \(supplementaryViewType.reuseIdentifier).")
        }
        return view
    }
}

extension UICollectionReusableView: ListReusable {}
