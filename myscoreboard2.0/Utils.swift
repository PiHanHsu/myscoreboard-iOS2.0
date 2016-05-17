//
//  Utils.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/18/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}