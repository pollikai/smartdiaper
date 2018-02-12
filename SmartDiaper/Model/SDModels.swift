//
//  SDPHModel.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/19/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

protocol SDAnalysisObject {
    var color: UIColor! { get }
}

protocol SDAnalysisObjectEditable {
    var tolerance: Int { get set}
}

struct SDColorNameModel: SDAnalysisObject, SDAnalysisObjectEditable {

    var color: UIColor!
    let name: String!
    var tolerance: Int

    init(color: UIColor, name: String) {
        self.color = color
        self.name = name
        self.tolerance = 0

    }
}

struct SDPHModel: SDAnalysisObject, SDAnalysisObjectEditable {

    var color: UIColor!
    let phValue: Int!
    var tolerance: Int

    init(color: UIColor, phValue: Int) {
        self.color = color
        self.phValue = phValue
        self.tolerance = 0

    }
}

struct SDSpecificGravityModel: SDAnalysisObject, SDAnalysisObjectEditable {
    var tolerance: Int

    var color: UIColor!
    let specificGravityValue: Double!

    init(color: UIColor, specificGravityValue: Double) {
        self.color = color
        self.specificGravityValue = specificGravityValue
        self.tolerance = 0
    }
}
