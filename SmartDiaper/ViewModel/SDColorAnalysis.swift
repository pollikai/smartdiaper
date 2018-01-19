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

    let specificGravityData: [SDSpecificGravityModel]!

    init() {

        self.specificGravityData = [SDSpecificGravityModel(color: UIColor(red: 23, green: 42, blue: 46),
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

        let mutableSpecificGravityData = specificGravityData.map { (specificGravity: SDSpecificGravityModel) -> SDSpecificGravityModel in
            var mutablespecificGravity = specificGravity
            let tolerance = colorsBecomeSimilarAtTolerance(color1: mutablespecificGravity.color, color2: color)
            mutablespecificGravity.tolerance = tolerance
            return mutablespecificGravity
        }
        
//        print(mutableSpecificGravityData)

        let result = mutableSpecificGravityData.min {firstElement, secondElement in firstElement.tolerance < secondElement.tolerance}

        return result
    }
}
