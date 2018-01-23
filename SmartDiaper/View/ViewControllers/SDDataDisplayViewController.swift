//
//  SDDataDisplayViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDDataDisplayViewController: UIViewController, UITableViewDataSource {

    private var viewModel: SDDataDisplayViewModel! = nil

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SDDataDisplayViewModel()

        self.tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {

        self.viewModel.refreshData()
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
        return self.viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = R.reuseIdentifier.sdDataDisplayTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell?.textLabel?.text = self.viewModel.textForCellAt(indexPath: indexPath)

        return cell!
    }

}
