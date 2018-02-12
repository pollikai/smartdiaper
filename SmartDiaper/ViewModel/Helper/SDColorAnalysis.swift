//
//  SDColorAnalysis.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/19/18.
//  Copyright © 2018 Starcut. All rights reserved.
//
import Foundation
import UIKit
struct SDColorAnalysis {

    let specificGravitySet: [SDSpecificGravityModel]!
    let phValuesSet: [SDPHModel]!
    let colorNameSet: [SDColorNameModel]!

    init() {

        self.specificGravitySet = [SDSpecificGravityModel(color: UIColor(red: 23, green: 42, blue: 46),
                                                      specificGravityValue: 1.000),
                               SDSpecificGravityModel(color: UIColor(red: 26, green: 46, blue: 35),
                                                      specificGravityValue: 1.005),
                               SDSpecificGravityModel(color: UIColor(red: 51, green: 68, blue: 32),
                                                      specificGravityValue: 1.010),
                               SDSpecificGravityModel(color: UIColor(red: 64, green: 68, blue: 17),
                                                      specificGravityValue: 1.015),
                               SDSpecificGravityModel(color: UIColor(red: 101, green: 78, blue: 2),
                                                      specificGravityValue: 1.020),
                               SDSpecificGravityModel(color: UIColor(red: 147, green: 108, blue: 15),
                                                      specificGravityValue: 1.025),
                               SDSpecificGravityModel(color: UIColor(red: 168, green: 106, blue: 29),
                                                      specificGravityValue: 1.030)]

        self.phValuesSet = [SDPHModel(color: UIColor(red: 180, green: 90, blue: 38), phValue: 5),
                                SDPHModel(color: UIColor(red: 170, green: 124, blue: 46), phValue: 6),
                                SDPHModel(color: UIColor(red: 121, green: 125, blue: 28), phValue: 7),
                                SDPHModel(color: UIColor(red: 73, green: 98, blue: 66), phValue: 8),
                                SDPHModel(color: UIColor(red: 21, green: 63, blue: 62), phValue: 9)]

        self.colorNameSet = [
            SDColorNameModel(color: UIColor(red: 237, green: 233, blue: 222), name: "Brie"),
            SDColorNameModel(color: UIColor(red: 245, green: 241, blue: 231), name: "Kalla"),
            SDColorNameModel(color: UIColor(red: 239, green: 241, blue: 237), name: "Opaali"),
            SDColorNameModel(color: UIColor(red: 198, green: 216, blue: 229), name: "Cumulus"),
            SDColorNameModel(color: UIColor(red: 208, green: 221, blue: 237), name: "Pisara"),
            SDColorNameModel(color: UIColor(red: 186, green: 205, blue: 147), name: "Helinä"),
            SDColorNameModel(color: UIColor(red: 77, green: 75, blue: 71), name: "Toro"),
            SDColorNameModel(color: UIColor(red: 80, green: 83, blue: 86), name: "Takorauta"),
            SDColorNameModel(color: UIColor(red: 63, green: 64, blue: 65), name: "Keskiyö")]

    }

    private func colorsBecomeSimilarAtTolerance(color1: UIColor?, color2: UIColor?) -> Int {

        if let color1 = color1, let color2 = color2 {

            for tolerance in 0...255 {

                let toleranceInFloat = CGFloat(tolerance)
                if color1.isEqualToColor(color: color2, withTolerance: toleranceInFloat/255.0) {
                    return tolerance
                }
            }
        }

        return 256 // can not be the cae, max tolerance value is 255
    }

    func specificGravityForColor(color: UIColor) -> SDSpecificGravityModel? {

        let mutableSGData = specificGravitySet.map { (sgModel: SDSpecificGravityModel) -> SDSpecificGravityModel in
            var mutablespecificGravity = sgModel
            let tolerance = colorsBecomeSimilarAtTolerance(color1: mutablespecificGravity.color, color2: color)
            mutablespecificGravity.tolerance = tolerance
            return mutablespecificGravity
        }

        let result = mutableSGData.min {first, second in first.tolerance < second.tolerance}

        return result
    }

    func phValueForColor(color: UIColor) -> SDPHModel? {

        let mutablePhValues = self.phValuesSet.map { (specificGravity: SDPHModel) -> SDPHModel in
            var mutablePhValue = specificGravity
            let tolerance = colorsBecomeSimilarAtTolerance(color1: mutablePhValue.color, color2: color)
            mutablePhValue.tolerance = tolerance
            return mutablePhValue
        }

        let result = mutablePhValues.min {first, second in first.tolerance < second.tolerance}

        return result
    }

    func nameForColorValue(color: UIColor) -> SDColorNameModel? {

        let mutableColorModels = self.colorNameSet.map { (colorNameModel: SDColorNameModel) -> SDColorNameModel in
            var mutableColorNameModel = colorNameModel
            let tolerance = colorsBecomeSimilarAtTolerance(color1: mutableColorNameModel.color, color2: color)
            mutableColorNameModel.tolerance = tolerance
            return mutableColorNameModel
        }

        let result = mutableColorModels.min {first, second in first.tolerance < second.tolerance}

        return result
    }

    func sortedCloseColorModels(color: UIColor) -> [SDColorNameModel]? {

        let mutableColorModels = self.colorNameSet.map { (colorNameModel: SDColorNameModel) -> SDColorNameModel in
            var mutableColorNameModel = colorNameModel
            let tolerance = colorsBecomeSimilarAtTolerance(color1: mutableColorNameModel.color, color2: color)
            mutableColorNameModel.tolerance = tolerance
            return mutableColorNameModel
        }

        return mutableColorModels.sorted(by: { $0.tolerance < $1.tolerance })
    }

}
