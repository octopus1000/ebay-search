//
//  sellerInfo.swift
//  ebay
//
//  Created by Tim on 4/23/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit
import SwiftyJSON


class sellerInfo:UIView{
    
    @IBOutlet var lbUsr: UILabel!
    @IBOutlet var lbFbScore: UILabel!
    @IBOutlet var lbPosFb: UILabel!
    @IBOutlet var lbFbRat: UILabel!
    @IBOutlet var lbStore: UILabel!
    @IBOutlet var imgTop: UIImageView!
    
    
    func loadSeller(seller:JSON){
        lbUsr.text = getTxt(seller["sellerUserName"]);
        lbFbScore.text = getTxt(seller["feedbackScore"]);
        lbPosFb.text = getTxt(seller["positiveFeedbackPercent"],surfix: "%");
        lbFbRat.text = getTxt(seller["feedbackRatingStar"]);
        
        if getTxt(seller["topRatedSeller"]).lowercaseString == "true" {
            imgTop.image = UIImage(named:"check-icon");
        }
        
        lbStore.text = getTxt(seller["sellerStoreName"]);
    }
}