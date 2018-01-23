//
//  SDDataDisplayViewModel.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDDataDisplayViewModel {

    private var data: [[String: Any]]?

    init() {
        self.refreshData()
    }

    func refreshData() {
        self.data = SDDatabaseManager.sharedInstance.savedResults()
    }

    func textForCellAt(indexPath: IndexPath) -> String {

        let dict = self.data![indexPath.row]

        let text = "\(dict[DBKeys.dateKey]!)     pH: \(dict[DBKeys.phKey]!)     SG: \(dict[DBKeys.specificGravityKey]!)"

        return text
    }

    func numberOfRows() -> Int {
        return self.data?.count ?? 0
    }

}
