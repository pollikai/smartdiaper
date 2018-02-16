//
//  SDDatabaseManager.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import Foundation

struct DBKeys {
    static var value1 = "value1"
    static var value2 = "value2"
    static var dateKey = "date_key"
    static var scanResultsKey = "scan_results_key"

}

class SDDatabaseManager {
    static let sharedInstance = SDDatabaseManager()

    private let defaults: UserDefaults

    private init() {
        //private init prevents others from using the default '()' initializer.
        //So only one PDDatabaseManager in application :D

        self.defaults = UserDefaults.standard
    }

    func saveResultInDB(specificGravity: Double?, phValue: Int?, timeStamp: String) {

        guard let specificGravity = specificGravity, let phValue = phValue else { return }

        if  var data = defaults.object(forKey: DBKeys.scanResultsKey) as? [[String: Any]] {

            let dict = [DBKeys.value1: phValue,
                        DBKeys.value2: specificGravity,
                        DBKeys.dateKey: timeStamp] as [String: Any]
            data.append(dict)

            defaults.set(data, forKey: DBKeys.scanResultsKey)

        } else {

            let dict = [DBKeys.value1: phValue,
                        DBKeys.value2: specificGravity,
                        DBKeys.dateKey: timeStamp] as [String: Any]

            var data = [[String: Any]]()
            data.append(dict)
            defaults.set(data, forKey: DBKeys.scanResultsKey)
        }

        defaults.synchronize()
    }

    func saveColorNameResultInDB(colorName: String?) {

        guard let colorNameString = colorName else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormatter.string(from: Date())

        if  var data = defaults.object(forKey: DBKeys.scanResultsKey) as? [[String: Any]] {

            let dict = [DBKeys.value2: colorNameString,
                        DBKeys.dateKey: dateString] as [String: Any]
            data.append(dict)

            defaults.set(data, forKey: DBKeys.scanResultsKey)

        } else {

            let dict = [DBKeys.value2: colorNameString,
                        DBKeys.dateKey: dateString] as [String: Any]

            var data = [[String: Any]]()
            data.append(dict)
            defaults.set(data, forKey: DBKeys.scanResultsKey)
        }

        defaults.synchronize()
    }

    func savedResults() -> [[String: Any]]? {
        if let data = UserDefaults.standard.object(forKey: DBKeys.scanResultsKey) as? [[String: Any]] {
            return data
        }
        return nil
    }
}
