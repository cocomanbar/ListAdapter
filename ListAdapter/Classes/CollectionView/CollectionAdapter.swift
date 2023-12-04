//
//  CollectionAdapter.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import UIKit

public typealias CollectionCellProvider = (UICollectionView, IndexPath, CollectionRow) -> UICollectionViewCell?

public class CollectionAdapter<S: CollectionSection, R: CollectionRow> : ListCommonAdapter {
    
    public var collectionViewCellClosure: ((UICollectionView, IndexPath, UICollectionViewCell) -> Void)?
    public var collectionViewDidSelectedClosure: ((UICollectionView, IndexPath, any ListDataRowable) -> Void)?
    public var collectionViewCellWillDisplayClosure: ((UICollectionView, UICollectionViewCell, IndexPath, any ListDataRowable) -> Void)?
    public var collectionViewCellDidEndDisplayClosure: ((UICollectionView, UICollectionViewCell, IndexPath, any ListDataRowable) -> Void)?
    public var collectionViewElementKindClosure:((UICollectionView, UICollectionReusableView, IndexPath, CollectionHeaderFooter) -> Void)?
    
    public let collectionView: UICollectionView
    private let cellProvider: CollectionCellProvider?
    
    private lazy var listLock: ListLock = {
        let lock = ListLock()
        lock.name = "CollectionAdapter.Lock"
        return lock
    }()
    
    private lazy var serialQueue = DispatchQueue(label: "com.CollectionAdapter.default")
    
    public init(with collectionView: UICollectionView, cellProvider: CollectionCellProvider? = nil) {
        self.collectionView = collectionView
        self.cellProvider = cellProvider
        super.init()
    }
    
    
    // MARK: - lazy
    
    public private(set) lazy var dataSource: CollectionDataSource<S, R> = {
        
        let cellProvider: CollectionCellProvider = cellProvider ?? { collectionView, indexPath, itemIdentifier in
            if let cell = itemIdentifier.rowReuseView {
                self.collectionViewCellClosure?(collectionView, indexPath, cell)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(with: itemIdentifier.rowType, for: indexPath)
            self.collectionViewCellClosure?(collectionView, indexPath, cell)
            return cell
        }
        return CollectionDataSource<S, R>(collectionView: collectionView, cellProvider: cellProvider)
    }()
    
    public private(set) lazy var delegate: CollectionDelegate<S, R> = {
        CollectionDelegate(adapter: self, dataSource: dataSource)
    }()
    
}


// MARK: - safe to apply

extension CollectionAdapter {
    
    public func apply(with provider: @escaping (_ dataSource: CollectionDataSource<S, R>, _ completion: @escaping () -> Void ) -> Void) {
        serialQueue.async {
            let completion = {
                if self.listLock.isBusy {
                    self.listLock.isBusy = false
                    debugPrint("【CollectionAdapter Log】- open")
                }
                self.listLock.unlock()
            }
            if self.listLock.try() {
                self.listLock.isBusy = false
                provider(self.dataSource, completion)
            } else {
                debugPrint("【CollectionAdapter Log】- lock")
                self.listLock.isBusy = true
                self.listLock.lock()
                provider(self.dataSource, completion)
            }
        }
    }
    
    public func apply(with provider: @escaping (_ dataSource: CollectionDataSource<S, R>) -> Void) {
        serialQueue.async {
            if self.listLock.try() {
                self.listLock.isBusy = false
                provider(self.dataSource)
                self.listLock.unlock()
            } else {
                debugPrint("【CollectionAdapter Log】- lock")
                self.listLock.lock()
                provider(self.dataSource)
                self.listLock.unlock()
                debugPrint("【CollectionAdapter Log】- open")
            }
        }
    }
    
}

public class CollectionDataSource<S: CollectionSection, R: CollectionRow>: UICollectionViewDiffableDataSource<S, R> {}

public class CollectionDelegate<S: CollectionSection, R: CollectionRow>: ListCommonDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var adapter: CollectionAdapter<S, R>?
    weak var dataSource: CollectionDataSource<S, R>?
    
    public init(adapter: CollectionAdapter<S, R>, dataSource: CollectionDataSource<S, R>) {
        self.adapter = adapter
        self.dataSource = dataSource
        super.init(commonAdapter: adapter)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let rowItem = dataSource?.itemIdentifier(for: indexPath) as? any ListDataRowable else { return }
        
        if let cell = cell as? ListUpdatable {
            cell.update(with: rowItem)
        }
        
        if let cell = cell as? ListWillDisplayable {
            cell.willDisplay(list: collectionView, row: cell, indexPath: indexPath, rowable: rowItem)
        }
        
        adapter?.collectionViewCellWillDisplayClosure?(collectionView, cell, indexPath, rowItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let rowItem = dataSource?.itemIdentifier(for: indexPath) as? any ListDataRowable else { return }
        
        if let cell = cell as? ListDidEndDisplayable {
            cell.didEndDisplay(list: collectionView, row: cell, indexPath: indexPath, rowable: rowItem)
        }
        
        adapter?.collectionViewCellDidEndDisplayClosure?(collectionView, cell, indexPath, rowItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let rowItem = dataSource?.itemIdentifier(for: indexPath) as? any ListDataRowable else { return }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ListDidSelectedable {
            cell.didSelected(list: collectionView, row: cell, indexPath: indexPath, rowable: rowItem)
        }
        
        adapter?.collectionViewDidSelectedClosure?(collectionView, indexPath, rowItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let sectionItem = dataSource?.sectionIdentifier(with: indexPath.section),
                  let header = sectionItem.header else { return UICollectionReusableView() }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(with: header.viewType, ofKind: kind, for: indexPath)
            if let headerView = headerView as? ListHeaderFooterUpdatable {
                headerView.update(with: header.viewData)
            }
            
            adapter?.collectionViewElementKindClosure?(collectionView, headerView, indexPath, header)
            return headerView
        } else {
            
            guard let sectionItem = dataSource?.sectionIdentifier(with: indexPath.section),
                  let footer = sectionItem.footer else { return UICollectionReusableView() }
            
            let footerView = collectionView.dequeueReusableSupplementaryView(with: footer.viewType, ofKind: kind, for: indexPath)
            if let footerView = footerView as? ListHeaderFooterUpdatable {
                footerView.update(with: footer.viewData)
            }
            
            adapter?.collectionViewElementKindClosure?(collectionView, footerView, indexPath, footer)
            return footerView
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let sectionItem = dataSource?.sectionIdentifier(with: section),
              let header = sectionItem.header else { return .zero }
        return CGSize(width: collectionView.frame.width, height: header.viewHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard let sectionItem = dataSource?.sectionIdentifier(with: section),
              let footer = sectionItem.footer else { return .zero }
        return CGSize(width: collectionView.frame.width, height: footer.viewHeight)
    }
    
}
