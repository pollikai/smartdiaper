//
//  SDTargetConfiguration.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 2/16/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import Foundation

class SDTargetConfiguration {

    enum Targets {
        case smartDiaper
        case colorAnalysis
    }

    private let currentTarget: Targets!

    init() {
        #if TARGET_SMART_DIAPER
            print("TARGET_SMART_DIAPER")
            self.currentTarget = .smartDiaper

        #elseif TARGET_COLOR_ANALYSIS
            print("TARGET_COLOR_ANALYSIS")
            self.currentTarget = .colorAnalysis
        #else
            print("no flag is specified for this target")
        #endif
    }

}
