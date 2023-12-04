//
//  BTestTableCell.swift
//  ListAdapter_Example
//
//  Created by tanxl on 2023/12/3.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ListAdapter

class BTestTableCell: TestTableCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BTestTableCell: ListDidSelectedable {
    
    struct Event {
        static let BTest = "BTestTableCell.BTest"
    }
    
    func didSelected<T, U>(list: T, row: U, indexPath: IndexPath, rowable: any ListDataRowable) {
        
        router(Event.BTest, with: self)
    }
}

