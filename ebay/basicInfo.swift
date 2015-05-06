//
//  basicInfo.swift
//  ebay
//
//  Created by Tim on 4/23/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit
import SwiftyJSON


class basicInfo:UIView{
  
    @IBOutlet var lbCat: UILabel!
    @IBOutlet var lbCond: UILabel!
    @IBOutlet var lbBuy: UILabel!
    
    func loadBasic(basic:JSON){
        lbCat.text =  getTxt(basic["categoryName"]);
        lbCond.text = getTxt(basic["conditionDisplayName"]);
        var buy:String =  getTxt(basic["listingType"]);
        
        if buy.lowercaseString.rangeOfString("fixedprice") != nil || buy.lowercaseString.rangeOfString("storeinventory") != nil{
            lbBuy.text = "Buy It Now"
        }
        else if buy.lowercaseString.rangeOfString("auction") != nil{
            lbBuy.text = "Auction";
        }
        else if buy.lowercaseString.rangeOfString("classified") != nil{
            lbBuy.text = "Classified Ad";
        }
        else {
            lbBuy.text = buy;
        }
    }
}



//a global utility function
func getTxt(entry: JSON?, surfix: String?=nil) -> String{
    
    if(entry == nil || entry?.stringValue == "")
    {
        return "N/A"
    }
    else{
        if (surfix == nil){
            return entry!.stringValue
        }
        else{
            return entry!.stringValue + surfix!
        }
    }
}

