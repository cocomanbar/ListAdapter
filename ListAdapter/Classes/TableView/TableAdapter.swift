//
//  TableAdapter.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import UIKit

public typealias TableCellProvider = (UITableView, IndexPath, TableRow) -> UITableViewCell?

public class TableAdapter<S: TableSection, R: TableRow> : ListCommonAdapter {
    
    public var tableViewCellClosure: ((UITableView, IndexPath) -> Void)?
    public var tableViewDidSelectedClosure: ((UITableView, IndexPath, any ListDataRowable) -> Void)?
    public var tableViewCellWillDisplayClosure: ((UITableView, UITableViewCell, IndexPath, any ListDataRowable) -> Void)?
    public var tableViewCellDidEndDisplayClosure: ((UITableView, UITableViewCell, IndexPath, any ListDataRowable) -> Void)?
    public var tableViewHeaderViewClosure: ((UITableView, UITableViewHeaderFooterView, Int, TableHeaderFooter) -> Void)?
    public var tableViewFooterViewClosure: ((UITableView, UITableViewHeaderFooterView, Int, TableHeaderFooter) -> Void)?
    
    public let tableView: UITableView
    private let cellProvider: TableCellProvider?
    
    private lazy var listLock: ListLock = {
        let lock = ListLock()
        lock.name = "TableAdapter.Lock"
        return lock
    }()
    
    private lazy var serialQueue = DispatchQueue(label: "com.TableAdapter.default")
    
    public init(with tableView: UITableView, cellProvider: TableCellProvider? = nil) {
        self.tableView = tableView
        self.cellProvider = cellProvider
        super.init()
    }
    
    
    // MARK: - lazy
    
    public private(set) lazy var dataSource: TableDataSource<S, R> = {
        
        let cellProvider: TableCellProvider = cellProvider ?? { tableView, indexPath, itemIdentifier in
            
            self.tableViewCellClosure?(tableView, indexPath)
            
            if let rowReuseView = itemIdentifier.rowReuseView {
                return rowReuseView
            }
            if let cell = tableView.dequeueReusableCell(with: itemIdentifier.rowType) {
                return cell
            }
            return UITableViewCell.init(style: .default, reuseIdentifier: itemIdentifier.rowType.reuseIdentifier)
        }
        return TableDataSource<S, R>(tableView: tableView, cellProvider: cellProvider)
    }()
    
    public private(set) lazy var delegate: TableDelegate<S, R> = {
        TableDelegate(adapter: self, dataSource: dataSource)
    }()
    
}


// MARK: - safe to apply

extension TableAdapter {
    
    public func apply(with provider: @escaping (_ dataSource: TableDataSource<S, R>, _ completion: @escaping () -> Void ) -> Void) {
        serialQueue.async {
            let completion = {
                if self.listLock.isBusy {
                    self.listLock.isBusy = false
                    debugPrint("【TableAdapter Log】- open")
                }
                self.listLock.unlock()
            }
            if self.listLock.try() {
                self.listLock.isBusy = false
                provider(self.dataSource, completion)
            } else {
                debugPrint("【TableAdapter Log】- lock")
                self.listLock.isBusy = true
                self.listLock.lock()
                provider(self.dataSource, completion)
            }
        }
    }
    
    public func apply(with provider: @escaping (_ dataSource: TableDataSource<S, R>) -> Void) {
        serialQueue.async {
            if self.listLock.try() {
                self.listLock.isBusy = false
                provider(self.dataSource)
                self.listLock.unlock()
            } else {
                debugPrint("【TableAdapter Log】- lock")
                self.listLock.lock()
                provider(self.dataSource)
                self.listLock.unlock()
                debugPrint("【TableAdapter Log】- open")
            }
        }
    }
    
}

public class TableDataSource<S: TableSection, R: TableRow>: UITableViewDiffableDataSource<S, R> {}

public class TableDelegate<S: TableSection, R: TableRow>: ListCommonDelegate, UITableViewDelegate {
    
    weak var adapter: TableAdapter<S, R>?
    weak var dataSource: TableDataSource<S, R>?
    
    public init(adapter: TableAdapter<S, R>, dataSource: TableDataSource<S, R>) {
        self.adapter = adapter
        self.dataSource = dataSource
        super.init(commonAdapter: adapter)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dataSource?.itemIdentifier(for: indexPath)?.rowHeight ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        dataSource?.sectionIdentifier(with: section)?.header?.viewHeight ?? CGFloat.leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        dataSource?.sectionIdentifier(with: section)?.footer?.viewHeight ?? CGFloat.leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = dataSource?.sectionIdentifier(with: section)?.header else { return nil }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(header.viewType)
        
        if headerView.frame == .zero {
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: header.viewHeight)
        }
        
        if let headerView = headerView as? ListHeaderFooterUpdatable {
            headerView.update(with: header.viewData)
        }
        
        adapter?.tableViewHeaderViewClosure?(tableView, headerView, section, header)
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footer = dataSource?.sectionIdentifier(with: section)?.footer else { return nil }
        
        let footerView = tableView.dequeueReusableHeaderFooterView(footer.viewType)
        
        if footerView.frame == .zero {
            footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footer.viewHeight)
        }
        
        if let footerView = footerView as? ListHeaderFooterUpdatable {
            footerView.update(with: footer.viewData)
        }
        
        adapter?.tableViewFooterViewClosure?(tableView, footerView, section, footer)
        
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let rowItem = dataSource?.itemIdentifier(for: indexPath) as? (any ListDataRowable) else { return }
        
        if let cell = cell as? ListUpdatable {
            cell.update(with: rowItem)
        }
        
        if let cell = cell as? ListWillDisplayable {
            cell.willDisplay(list: tableView, row: cell, indexPath: indexPath, rowable: rowItem)
        }
        
        adapter?.tableViewCellWillDisplayClosure?(tableView, cell, indexPath, rowItem)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let rowItem = dataSource?.itemIdentifier(for: indexPath) as? (any ListDataRowable) else { return }
        
        if let cell = cell as? ListDidEndDisplayable {
            cell.didEndDisplay(list: tableView, row: cell, indexPath: indexPath, rowable: rowItem)
        }
        
        adapter?.tableViewCellDidEndDisplayClosure?(tableView, cell, indexPath, rowItem)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let rowItem = dataSource?.itemIdentifier(for: indexPath) as? (any ListDataRowable) else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) as? ListDidSelectedable {
            cell.didSelected(list: tableView, row: cell, indexPath: indexPath, rowable: rowItem)
        }
        
        adapter?.tableViewDidSelectedClosure?(tableView, indexPath, rowItem)
    }
}
