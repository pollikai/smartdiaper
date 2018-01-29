//
//  UIView+Extentions.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/11/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit
extension UIView {

    var frameInSuperView: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

extension UIView {

    func snapshot(of rect: CGRect? = nil) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // if no `rect` provided, return image of whole view

        guard let image = wholeImage, let rect = rect else { return wholeImage }

        // otherwise, grab specified `rect` of image

        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale,
                                y: rect.origin.y * scale,
                                width: rect.size.width * scale,
                                height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }

    func addShadowWithMargin(margin: CGFloat = 1.0) {

        let shadowPath = UIBezierPath(rect: CGRect(x: -margin / 2,
                                                   y: -margin / 2,
                                                   width: self.frame.size.width + margin,
                                                   height: self.frame.size.height + margin + 20))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath

    }
}
