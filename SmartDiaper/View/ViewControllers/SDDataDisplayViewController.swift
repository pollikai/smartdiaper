//
//  SDDataDisplayViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDDataDisplayViewController: UIViewController, UITableViewDataSource {

    var data: [[String: Any]]? = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.object(forKey: "scan_results") as? [[String: Any]] {
            self.data = data
        }

        self.tableView.reloadData()
    }

    @IBAction func startScanningButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier:
            R.segue.sdDataDisplayViewController.sdavCaptureViewController.identifier,
                          sender: nil)

    }
}

extension SDDataDisplayViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = R.reuseIdentifier.sdDataDisplayTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let dict = self.data![indexPath.row]

        cell?.textLabel?.text = "\(dict["date"]!)     pH: \(dict["ph"]!)     SG: \(dict["specific_gravity"]!)"

        return cell!
    }

}
