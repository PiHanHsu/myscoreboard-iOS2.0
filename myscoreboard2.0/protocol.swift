//
//  protocol.swift
//  MyScoreBoardapp
//
//  Created by MBPrDyson on 5/4/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

protocol passwordCellDelegate{
    func getToDestinationController()
}

protocol labelCellDelegate {
    func getText(type: TextFieldType , enterText: String )
    func callPicker(sender: UITableViewCell , pickerContent: [String] )
}

protocol pickerDelegate{
    func didSelect(pickerType:PickerType,pickerItem:String)
}

protocol buttonCellDelegate{
    func buttonClick(buttonType:ButtonType)
}