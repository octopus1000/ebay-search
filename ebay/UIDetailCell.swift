//
//  UIDetailCell.swift
//  ebay
//
//  Created by Tim on 4/22/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit
import BFPaperTableViewCell

class UIDetailCell:BFPaperTableViewCell{
    
    
    @IBOutlet var view: UIView!
    
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("UIDetailCell", owner: self, options: nil)
        view.frame = self.bounds
        view.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.addSubview(view)
    }
    
}
