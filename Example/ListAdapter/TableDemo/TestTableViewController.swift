//
//  TestTableViewController.swift
//  ListAdapter_Example
//
//  Created by tanxl on 2023/12/3.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import Combine
import ListAdapter

class TableSectionItem: TableSection {}

class TableRowItem: TableRow {
    var number: Int = 0
}

class TestTableViewController: UIViewController {

    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        tableView.dataSource = adapter.dataSource
        tableView.delegate = adapter.delegate
        tableView.register(with: ATestTableCell.self)
        tableView.register(with: BTestTableCell.self)
        view.addSubview(tableView)
        
        
        // kvo for scroll status
        cancellable = adapter.delegate.$scrollStatus.sink(receiveValue: { status in
            print("status = \(status)")
        })
        
        initData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    private func initData() {
        
        self.adapter.apply { dataSource, completion in
            
            var snapshot = dataSource.snapshot()
            
            // 先配置组
            let section = TableSectionItem(listId: Section.main.rawValue)
            snapshot.appendSections([section])
            
            // 再往组里插数据
            let rowItem1 = TableRowItem(rowData: Row.main1, rowType: ATestTableCell.self, rowHeight: 100)
            let rowItem2 = TableRowItem(rowData: Row.main2, rowType: ATestTableCell.self, rowHeight: 130)
            let rowItem3 = TableRowItem(rowData: Row.main3, rowType: ATestTableCell.self, rowHeight: 140)
            let rowItem4 = TableRowItem(rowData: Row.main4, rowType: ATestTableCell.self, rowHeight: 150)
            let rowItem5 = TableRowItem(rowData: Row.main5, rowType: ATestTableCell.self, rowHeight: 160)
            snapshot.appendItems([rowItem1, rowItem2, rowItem3, rowItem4, rowItem5], toSection: section)
            
            dataSource.apply(snapshot, animatingDifferences: true) {
                completion()
            }
            
        }
                
        self.adapter.apply { dataSource, completion in
            
            var snapshot = dataSource.snapshot()

            // 先配置组
            let section = TableSectionItem(listId: Section.food.rawValue)
            snapshot.appendSections([section])
            
            // 再往组里插数据
            let rowItem1 = TableRowItem(rowData: Row.food1, rowType: BTestTableCell.self, rowHeight: 100)
            let rowItem2 = TableRowItem(rowData: Row.food2, rowType: BTestTableCell.self, rowHeight: 130)
            let rowItem3 = TableRowItem(rowData: Row.food3, rowType: BTestTableCell.self, rowHeight: 140)
            let rowItem4 = TableRowItem(rowData: Row.food4, rowType: BTestTableCell.self, rowHeight: 150)
            let rowItem5 = TableRowItem(rowData: Row.food5, rowType: BTestTableCell.self, rowHeight: 160)
            snapshot.appendItems([rowItem1, rowItem2, rowItem3, rowItem4, rowItem5], toSection: section)
                        
            self.adapter.dataSource.apply(snapshot, animatingDifferences: true) {
                completion()
            }
        }
        
    }
    
    
    override func router(_ event: String, with paramter: Any?) {
        
        if event == BTestTableCell.Event.BTest {
            
            if let cell = paramter as? BTestTableCell {
                debugPrint("params: \(cell)")
            }
            
        } else if event == ATestTableCell.Event.ATest {
            
            if let cell = paramter as? ATestTableCell {
                debugPrint("params: \(cell)")
            }
            
        } else {
            // if it needed?
            // super.router(event, with: paramter)
        }
    }
    
    // MARK: - lazy

    private lazy var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private lazy var adapter: TableAdapter<TableSectionItem, TableRowItem> = TableAdapter<TableSectionItem, TableRowItem>(with: tableView)
}


enum Section: String, ListIdentifiable {
    case main
    case food
    case text
    
    var listId: String {
        "\(self)"
    }
}

enum Row: String, ListIdentifiable {
    case none
    
    case main1
    case main2
    case main3
    case main4
    case main5
    
    case food1
    case food2
    case food3
    case food4
    case food5
    
    case text
    
    var listId: String {
        "\(self)"
    }
}
