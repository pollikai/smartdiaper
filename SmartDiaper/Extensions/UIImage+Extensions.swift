//
//  UIImage+Extensions.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/10/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {

    func pixelColorAtPoint(pos: CGPoint) -> UIColor? {

        guard let cgImage = self.cgImage else {return nil}

        let pixelData = cgImage.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
