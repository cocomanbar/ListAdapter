//
//  TestTableCell.swift
//  ListAdapter_Example
//
//  Created by tanxl on 2023/12/3.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ListAdapter

class TestTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TestTableCell: ListUpdatable {
    
    func update(with rowItem: any ListDataRowable) {
        
        guard let row = rowItem.rowData as? Row else { return }
        textLabel?.text = "\(rowItem.rowData.listId), num: \(row)"
    }
    
}


extension TestTableCell: ListDidEndDisplayable {
    
    func didEndDisplay<T, U>(list: T, row: U, indexPath: IndexPath, rowable: any ListDataRowable) {
        textLabel?.text = nil
    }
}
