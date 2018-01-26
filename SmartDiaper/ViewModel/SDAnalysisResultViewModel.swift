//
//  SDAnalysisResultViewModel.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDAnalysisResultViewModel {

    private let colorAnalysis: SDColorAnalysis

    private var latestSpecificGravityModel: SDSpecificGravityModel?
    private var latestPHModel: SDPHModel?

    init() {
        self.colorAnalysis = SDColorAnalysis()
    }

    func specificGravityForColor(color: UIColor) -> String {
        let specificGravity = colorAnalysis.specificGravityForColor(color: color)
        self.latestSpecificGravityModel = specificGravity

        return String(format: "%.3f", specificGravity!.specificGravityValue)
    }

    func phValueForColor(color: UIColor) -> String {
        let phModel = colorAnalysis.phValueForColor(color: color)
        self.latestPHModel = phModel

        return String(format: "%d", phModel!.phValue)
    }

    func saveData() {
        if self.latestSpecificGravityModel != nil, self.latestPHModel != nil {
            SDDatabaseManager.sharedInstance.saveResultInDB(
                specificGravity: self.latestSpecificGravityModel?.specificGravityValue,
                phValue: self.latestPHModel?.phValue)
        }
    }

    deinit {
    }
}
