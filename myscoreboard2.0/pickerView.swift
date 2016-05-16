//
//  pickerView.swift
//  MyScoreBoardapp
//
//  Created by MBPrDyson on 5/7/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class PickerView: UIView,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerType:PickerType?
    var delegate:pickerDelegate?
    var pickerContent:[String] = []
    var selectRow:Int = 0
    
    @IBOutlet weak var titleLabelInVIew: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBAction func didSelectPickerAction(sender: UIButton) {
        self.delegate?.didSelect(self.pickerType!, pickerItem: self.pickerContent[self.selectRow])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("end picker : \(row)")
        self.selectRow = row
    }
    
    // MARK: - UIPickerViewDataSource
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerContent.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerContent[row]
    }
    
}
