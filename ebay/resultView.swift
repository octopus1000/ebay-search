//
//  resultView.swift
//  ebayFind
//
//  Created by Tim on 4/19/15.
//  Copyright (c) 2015 x. All rights reserved.
//
import UIKit
import SwiftyJSON

class resultView: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var tbl: UITableView!
    
     var items: JSON? = nil;//json object
    let textCellIdentifier = "TextCell"
    var keywords:String! = nil;
    
    @IBOutlet var lbres: UILabel!
    override  func viewDidLoad() {

        tbl.rowHeight = UITableViewAutomaticDimension;
        tbl.estimatedRowHeight = 150.0
        
        if keywords != nil{
          lbres.text = "Results for '\(keywords)'"
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //force reload to make height appropriate
        tbl.reloadData();

    }
    

    
    //table data source fun
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items != nil) ? items!.count : 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tbl.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! itemCell
        
        let row = indexPath.row
        
        var separ:UIView = UIView(frame:CGRectMake(0, 0, view.frame.size.width,3));
        separ.backgroundColor = UIColor(red: 217.0/255, green: 37.0/255, blue: 76.0/255, alpha: 1);
        cell.contentView.addSubview(separ);
        
        if items != nil{
            
            //set title
            cell.title.text = items![row]["basicInfo"]["title"].stringValue;
            
            //set ship cost
            let shipCost = items![row]["basicInfo"]["shippingServiceCost"].floatValue;
            cell.detail.text = shipCost == 0 ? "(FREE SHIPPING)" : "(+$ \(shipCost) SHIPPING)";
            cell.link = items![row]["basicInfo"]["viewItemURL"].string;
            //custom cell appearance
            
            //magic code to wrap label!
            cell.setNeedsDisplay();
            cell.layoutIfNeeded();
            
            
            //asyncronous load image
            if let url = NSURL(string: items![row]["basicInfo"]["galleryURL"].string!) {
                NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                    //completion(data: NSData(data: data))
                    println("Image downloaded");
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.img.image = UIImage(data: data);
                    });
                    
                    }.resume()
            }
        }
        
        return cell
    }
    
    
    //table delegate fun
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        performSegueWithIdentifier("showDetail", sender: self);
        
    }
    
    
    //perform segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let indexPath = tbl.indexPathForSelectedRow(){
            println("select row \(indexPath.row)");
            tbl.deselectRowAtIndexPath(indexPath, animated: true);
             (segue.destinationViewController as! detailVC).item = items![indexPath.row];
        }
        
    }

}
