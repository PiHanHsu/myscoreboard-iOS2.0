//
//  Utils.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/18/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}

extension Array
{
    mutating func shuffle() -> [Element] {
        for _ in 0...self.count {
            let r = Int(arc4random_uniform(UInt32(self.count)))
            self.insert(self.removeAtIndex(r), atIndex: 0)
        }
        return self
    }
    
}

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}


extension UIView
{
    func applyHoverShadow(view: UIView) {
        let size = view.bounds.size
        let width = size.width
        let height = size.height
        
        let ovalRect = CGRect(x: 5, y: height + 5, width: width - 10, height: 15)
        let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
        
        let layer = view.layer
        layer.shadowPath = path.CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}