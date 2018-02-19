//
//  SDResultHeaderFooterView.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/26/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDResultHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    func setLabel1(text: String) {
        label1.text = text
    }

    func setLabel2(text: String) {
        label2.text = text
    }

}
