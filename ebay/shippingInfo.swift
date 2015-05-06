//
//  shippingInfo.swift
//  ebay
//
//  Created by Tim on 4/23/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit
import SwiftyJSON

class shippingInfo:UIView{
    
    @IBOutlet var lbType: UILabel!
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var lbToLoc: UILabel!
    
    @IBOutlet var imgExp: UIImageView!
    @IBOutlet var imgOneD: UIImageView!
    @IBOutlet var imgRet: UIImageView!
    
    func loadShip(ship:JSON){
       lbType.text=getTxt(ship["shippingType"]);
        lbTime.text=getTxt(ship["handlingTime"],surfix: " day(s)");
        lbToLoc.text=getTxt(ship["shipToLocations"]);
        
        if getTxt(ship["expeditedShipping"]).lowercaseString == "true"{
            imgExp.image = UIImage(named: "check-icon");
        }
        println(ship["expeditedShipping"])
        
        if getTxt(ship["oneDayShippingAvailable"]).lowercaseString == "true"{
         self.imgOneD.image = UIImage(named: "check-icon");
        }
        
        println(ship["oneDayShippingAvailable"]);
        if getTxt(ship["returnsAccepted"]).lowercaseString == "true"{
            self.imgRet.image = UIImage(named: "check-icon");
        }
        println(ship["returnsAccepted"]);
    }

}