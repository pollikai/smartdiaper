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

    func textForCellAt(indexPath: IndexPath) -> (String, String, String) {

        let dict = self.data![indexPath.row]
        let dateText = "\(dict[DBKeys.dateKey]!)"
        let phText = "pH: \(dict[DBKeys.phKey]!)"
        let specifigGravityText = "SG: \(dict[DBKeys.specificGravityKey]!)"

        return (dateText, phText, specifigGravityText)
    }

    func numberOfRows() -> Int {
        return self.data?.count ?? 0
    }

}
