//
//  detailVC.swift
//  ebay
//
//  Created by Tim on 4/21/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast

class detailVC:UIViewController,FBSDKSharingDelegate{
    
    var item:JSON! = nil;
    
    //ui
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var imgTop: UIImageView!

    @IBOutlet var lbPrice: UILabel!
    @IBOutlet var lbLoc: UILabel!
    
    @IBOutlet var scroll2: UIScrollView!
    
    
    func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    
    override func viewDidLoad() {
        
        if let basic = item?["basicInfo"]{
            
            lbTitle.text = basic["title"].string;
            
            var price = "Price:$" + basic["convertedCurrentPrice"].string!;
            let shipCost = basic["shippingServiceCost"].floatValue
            price += shipCost == 0 ? "(FREE SHIPPING)" : "(+$ \(shipCost) SHIPPING)";
            lbPrice.text = price;
            
            lbLoc.text = basic["location"].string;
            
            if getTxt(basic["topRatedListing"]).lowercaseString != "true"{
                imgTop.hidden = true;
            }
            
            var imgUrl: NSURL? = NSURL(string:basic["pictureURLSuperSize"].string!);
            
            if imgUrl == nil || imgUrl?.absoluteString == ""{
            imgUrl = NSURL(string:basic["galleryURL"].string!);
            }
            if imgUrl != nil{
                NSURLSession.sharedSession().dataTaskWithURL(imgUrl!) { (data, response, error) in
                    //completion(data: NSData(data: data))
                    println("Image downloaded");
                    dispatch_async(dispatch_get_main_queue(), {
                        self.img.image = UIImage(data: data);
                    });
                    
                    }.resume()
            }
            //ct1.frame.size.width = 300;
            
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        //set scroll view
        
        var views = NSMutableArray();
        var width = scroll2.frame.size.width;
        var height = scroll2.frame.size.height;
        
        scroll2.contentSize = CGSizeMake(width*3,height);
        
        if let vBasicInfo:basicInfo = (self.loadFromNibNamed("basicInfo") as? basicInfo){
            views.addObject(vBasicInfo);
            vBasicInfo.loadBasic(item["basicInfo"]);
        }
        
        if let vSellerInfo:sellerInfo = (self.loadFromNibNamed("sellerInfo") as? sellerInfo){
            views.addObject(vSellerInfo);
            vSellerInfo.loadSeller(item["sellerInfo"]);
            
        }
        
        if let vShippingInfo:shippingInfo = (self.loadFromNibNamed("shippingInfo") as? shippingInfo){
            views.addObject(vShippingInfo);
            vShippingInfo.loadShip(item["shippingInfo"]);
        }
        
        for var i = 0; i < views.count ; ++i{
            let subview = views[i] as! UIView;
            subview.frame.size.width = width;
            subview.frame.origin.x = width * CGFloat(i);
            scroll2.addSubview(subview);
        }
        
        
       
    }
    
    
    //control scroll view in pages
    @IBOutlet var sgCtr: UISegmentedControl!
    @IBAction func scrollToSection(sender: UISegmentedControl) {
        
        let page = sgCtr.selectedSegmentIndex;
        scroll2.setContentOffset(CGPoint(x: scroll2.frame.size.width * CGFloat(page), y: 0), animated: false)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!){
        
        var page = Float(scrollView.contentOffset.x / scrollView.frame.size.width);
        
        sgCtr.selectedSegmentIndex = Int(page + 0.5);
        
    }
    
    
    //buy now button
    @IBAction func openLinkInBrowser(sender: AnyObject) {
        if let url = NSURL(string: item["basicInfo"]["viewItemURL"].string!){
            UIApplication.sharedApplication().openURL(url);
        }
        else{
            self.view.makeToast("fail to get link T T");
        }
        
    }
    
    
    
    //fbshare
    @IBAction func shareFB(sender: AnyObject) {
        
        if let url = item?["basicInfo"]["viewItemURL"].string{
            
            var content:FBSDKShareLinkContent = FBSDKShareLinkContent();
            
            content.contentURL = NSURL(string:url);
            content.contentTitle = lbTitle.text;
            content.contentDescription = lbPrice.text! + lbLoc.text!;
            
            if let imgURL = item?["basicInfo"]["galleryURL"].string{
                if let nsurl = NSURL(string:imgURL){
                    content.imageURL = nsurl;
                }
            }
            
            FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self);
        }

    }
    
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject: AnyObject]){
        if results.isEmpty {
            println("cancelled");
            self.view.makeToast("share cancelled");
        }
        else{
            println(results);
            self.view.makeToast("share success");
        }
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
        println("sharer NSError")
        println(error.description)
        
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
        println("sharerDidCancel")
        
    }
    
}


