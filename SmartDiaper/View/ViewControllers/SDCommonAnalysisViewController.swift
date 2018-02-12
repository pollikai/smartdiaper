//
//  SDCommonAnalysisViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 2/12/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDCommonAnalysisViewController: UIViewController {

    var image: UIImage!
    var viewModel: SDAnalysisResultViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SDAnalysisResultViewModel()

    }

}
