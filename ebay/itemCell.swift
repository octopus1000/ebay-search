//
//  itemCell.swift
//  ebay
//
//  Created by Tim on 4/21/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit
import BFPaperTableViewCell

class itemCell:BFPaperTableViewCell{
    @IBOutlet var img: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var detail: UILabel!
    
    
    
    var link:String? = nil
    
    @IBAction func goToLink(sender: UIButton) {
        if link == nil {
            println("error:no link acquired");
            return;
        }
        if let url = NSURL(string:link!){
          UIApplication.sharedApplication().openURL(url);
        }
    }
    
    
}

