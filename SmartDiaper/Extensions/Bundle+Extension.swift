//
//  Bundle+Extension.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 2/16/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import Foundation

extension Bundle {

    class func targetName() -> String {
        let targetName = main.infoDictionary?["CFBundleName"] as? String ?? ""
        return targetName
    }

}
