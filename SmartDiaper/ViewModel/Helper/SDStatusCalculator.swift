//
//  SDStatusCalculator.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 3/5/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import Foundation

struct SDStatusCalculator {

    enum SpecificGravityStatus: String {
        case normal = "Normal"
        case bitLow = "Bit Low"
        case low = "Low"
        case invalidSpecificGravityValue = "invalidSpecificGravityValue Value"
    }

    enum PHStatus: String {
        case acid = "Acid"
        case normal = "Normal"
        case basic = "Basic"
        case invalidPHValue = "invalidPHValue Value"
    }

    func statusForSpecificGravityModel(model: SDSpecificGravityModel) -> SpecificGravityStatus {

        guard let value = model.specificGravityValue else {return .invalidSpecificGravityValue}

        if value < 1.010 {
            return .normal
        } else if value > 1.020 {
            return .low
        }
        return .bitLow
    }

    func statusForPHModel(model: SDPHModel) -> PHStatus {

        guard let value = model.phValue else {return .invalidPHValue}

        if value < 7 {
            return .acid
        } else if value > 7 {
            return .basic
        }
        return .normal
    }

}
