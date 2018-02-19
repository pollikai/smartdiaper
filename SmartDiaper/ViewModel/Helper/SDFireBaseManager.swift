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
}
