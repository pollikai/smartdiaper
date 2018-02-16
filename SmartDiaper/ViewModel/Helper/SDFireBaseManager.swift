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
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        rootDB = ref.child(Bundle.targetName()).child(configuration).child(deviceId)
    }

    func saveScanned(specificGravity: Double, phValue: Int, timeStamp: String) {

        let post = ["timestamp": timeStamp,
                    "specificGravity": specificGravity,
                    "ph": phValue] as [String: Any]

        let locationRef = rootDB.childByAutoId()
        locationRef.setValue(post)
    }
}
