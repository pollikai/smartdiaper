//
//  SDFireBaseManager.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 2/16/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class SDFireBaseManager {

    #if DEBUG
        private let configuration = "staging"
    #else
        private let configuration = "production"
    #endif

    static let sharedInstance = SDFireBaseManager()

    private let rootDB: DatabaseReference!

    private init() {
        FirebaseApp.configure()
        let ref = Database.database().reference()

        rootDB = ref.child(Bundle.targetName()).child(configuration)
    }

    func saveScanned(specificGravity: Double, phValue: Int, timeStamp: String) {

        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let deviceName = UIDevice.current.name
        let uniqueId = deviceName + "__" + deviceId

        let post = ["timestamp": timeStamp,
                    "specificGravity": specificGravity,
                    "ph": phValue,
                    "deviceId": uniqueId] as [String: Any]

        let locationRef = rootDB.childByAutoId()
        locationRef.setValue(post)

    }

    func exportToCSV() {

        let fileName = "data"
        let path = NSURL(fileURLWithPath: "/Users/startcut/Desktop").appendingPathComponent(fileName)
        var csvText = "TimeStamp,ph, SpecificGravity,deviceId\n"

        rootDB.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject] ?? [:]

            for (_, value) in postDict {
//                print("\(key) = \(value)")

                let dataEntry = value as? [String: AnyObject]

                let ph = String(format: "%d", dataEntry!["ph"] as? Int ?? 0)
                let sg = String(format: "%f", dataEntry!["specificGravity"] as? Double ?? 0.0)
                let deviceId = dataEntry!["deviceId"] as? String ?? ""
                let timeStamp = dataEntry!["timestamp"] as? String ?? ""

                let newLine = "\(timeStamp), \(ph), \(sg), \(deviceId)\n"
                csvText.append(newLine)
            }

            DispatchQueue.main.async {
                do {
                    try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    print("Failed to create file")
                    print("\(error)")
                }
                print(path ?? "not found")
            }

        })

    }

}
