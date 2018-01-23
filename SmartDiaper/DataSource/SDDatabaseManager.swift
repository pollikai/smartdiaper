//
//  SDDatabaseManager.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import Foundation

struct DBKeys {
    static var phKey = "ph_key"
    static var specificGravityKey = "specific_gravit_key"
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

    func saveResultInDB(specificGravity: Double?, phValue: Int?) {

        guard let specificGravity = specificGravity, let phValue = phValue else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormatter.string(from: Date())

        if  var data = defaults.object(forKey: DBKeys.scanResultsKey) as? [[String: Any]] {

            let dict = [DBKeys.phKey: phValue,
                        DBKeys.specificGravityKey: specificGravity,
                        DBKeys.dateKey: dateString] as [String: Any]
            data.append(dict)

            defaults.set(data, forKey: DBKeys.scanResultsKey)

        } else {

            let dict = [DBKeys.phKey: phValue,
                        DBKeys.specificGravityKey: specificGravity,
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
