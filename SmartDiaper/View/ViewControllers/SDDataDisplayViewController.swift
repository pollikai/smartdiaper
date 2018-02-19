//
//  SDDataDisplayViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDDataDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var viewModel: SDDataDisplayViewModel! = nil

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBackgroundShadowView: UIView!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SDDataDisplayViewModel()

        tableBackgroundShadowView.layer.cornerRadius = 5

        tableBackgroundShadowView.addShadow()

        self.tableView.register(R.nib.sdResultDataTableViewCell(),
                                forCellReuseIdentifier: R.reuseIdentifier.sdResultDataTableViewCell.identifier)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

        tableView.register(R.nib.sdResultHeaderFooterView(),
                           forHeaderFooterViewReuseIdentifier: String(describing: SDResultHeaderFooterView.self))

        self.tableView.dataSource = self
        self.tableView.delegate = self
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

    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            String(describing: SDResultHeaderFooterView.self)) as? SDResultHeaderFooterView

        let config = SDTargetConfiguration()

        if config.target == .colorAnalysis {
            headerView?.setLabel1(text: "")
            headerView?.setLabel2(text: "Color")
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            String(describing: SDResultHeaderFooterView.self)) as? SDResultHeaderFooterView
        return (headerView?.frame.height)!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = R.reuseIdentifier.sdResultDataTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)

        let (date, ph, specifigGravity) = self.viewModel.textForCellAt(indexPath: indexPath)
        cell?.dateLabel?.text = date
        cell?.phLabel?.text = ph
        cell?.specifigGravityLabel?.text = specifigGravity
        cell?.layer.backgroundColor = UIColor.clear.cgColor
        return cell!
    }

}
