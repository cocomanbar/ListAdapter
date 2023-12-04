//
//  UITableView.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import UIKit

extension UITableViewCell: ListReusable { }
extension UITableViewHeaderFooterView: ListReusable { }

public extension UITableView {
    
    func register<Cell: UITableViewCell>(with cellType: Cell.Type) {
        self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        self.register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(with cellType: Cell.Type) -> Cell? {
        return self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? Cell
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(with cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier).")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) -> T {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T else {
            fatalError("Failed to dequeue a view with identifier \(viewType.reuseIdentifier).")
        }
        return view
    }
}
