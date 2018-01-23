//
//  SDDataDisplayViewModel.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDDataDisplayViewModel {

    private var data: [[String: Any]]? = []

    init() {
        self.refreshData()
    }

    func refreshData() {
        if let data = UserDefaults.standard.object(forKey: "scan_results") as? [[String: Any]] {
            self.data = data
        }
    }
    
    func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = R.reuseIdentifier.sdDataDisplayTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let dict = self.data![indexPath.row]

        cell?.textLabel?.text = "\(dict["date"]!)     pH: \(dict["ph"]!)     SG: \(dict["specific_gravity"]!)"

        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }
}
