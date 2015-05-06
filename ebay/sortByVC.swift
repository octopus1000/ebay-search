//
//  sortByVC.swift
//  ebayFind
//
//  Created by Tim on 4/19/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit

protocol SortByDel{
    func sortByFinished(controller:sortByVC, ret:Int)
}

let sort = ["Best Match","Price: highest first","Price + Shipping: highest first","Price + Shipping:lowest first"]

class sortByVC: UIViewController {
    
    
    var choosed = -1;
    var del:SortByDel! = nil
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sort.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return sort[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosed = row;
    }
    @IBAction func sortSelect(sender: AnyObject) {
        del.sortByFinished(self, ret: choosed)
    }
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

