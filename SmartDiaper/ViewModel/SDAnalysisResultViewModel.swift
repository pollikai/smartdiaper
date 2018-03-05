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

    private func specificGravityModelForColor(color: UIColor) -> SDSpecificGravityModel? {
        let specificGravity = colorAnalysis.specificGravityForColor(color: color)
        return specificGravity
    }

    private func phModelForColor(color: UIColor) -> SDPHModel? {
        let phModel = colorAnalysis.phValueForColor(color: color)
        return phModel
    }

    func specificGravityForColor(color: UIColor) -> String {
        let specificGravity = specificGravityModelForColor(color: color)
        self.latestSpecificGravityModel = specificGravity

        return String(format: "%.3f", specificGravity!.specificGravityValue)
    }

    func phValueForColor(color: UIColor) -> String {
        let phModel = phModelForColor(color: color)
        self.latestPHModel = phModel

        return String(format: "%d", phModel!.phValue)
    }

    func specificGravityStatusForColor(color: UIColor) -> String {
        let statusCalculator = SDStatusCalculator()

        let specificGravityModel = specificGravityModelForColor(color: color)

        let status = statusCalculator.statusForSpecificGravityModel(model: specificGravityModel!)

        return status.rawValue

    }

    func phStatusForColor(color: UIColor) -> String {
        let statusCalculator = SDStatusCalculator()

        let phModel = colorAnalysis.phValueForColor(color: color)

        let status = statusCalculator.statusForPHModel(model: phModel!)

        return status.rawValue

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
