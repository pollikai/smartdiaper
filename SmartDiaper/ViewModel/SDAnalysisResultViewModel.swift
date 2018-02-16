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
    private var latestColorNameModel: SDColorNameModel?

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

    func nameForColorValue(color: UIColor) -> String {
        let colorNameModel = colorAnalysis.nameForColorValue(color: color)
        self.latestColorNameModel = colorNameModel

        return String(format: "%@", colorNameModel!.name)
    }

    func sortedCloseColorModels(color: UIColor) -> [SDColorNameModel]? {
        let colorNameModels = colorAnalysis.sortedCloseColorModels(color: color)

        return colorNameModels
    }

    func saveDataPHandSG() {

        guard let sgValue = self.latestSpecificGravityModel?.specificGravityValue,
            let phValue = self.latestPHModel?.phValue
            else {
                return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormatter.string(from: Date())

        if self.latestSpecificGravityModel != nil, self.latestPHModel != nil {
            SDDatabaseManager.sharedInstance.saveResultInDB(
                specificGravity: sgValue,
                phValue: phValue,
                timeStamp: dateString)
        }

        let targetConfig = SDTargetConfiguration()

        if targetConfig.target == .smartDiaper {
            SDFireBaseManager.sharedInstance.saveScanned(specificGravity: sgValue,
                                                         phValue: phValue,
                                                         timeStamp: dateString)
        }
    }

    func saveColorName() {
        if self.latestColorNameModel != nil {
            SDDatabaseManager.sharedInstance.saveColorNameResultInDB(colorName: self.latestColorNameModel?.name)
        }
    }

    #if DEBUG
    deinit {
        print("deinit")
    }
    #endif

}
