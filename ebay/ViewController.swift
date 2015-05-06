//
//  ViewController.swift
//  ebayFind
//
//  Created by Tim on 4/19/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast

/*sort[]: a global var*/

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
   func isFloat() -> Bool {
    let regex = "[+]?[0-9]*\\.?[0-9]+";
    let test = NSPredicate(format:"SELF MATCHES %@", regex);
    var ret = test.evaluateWithObject(self);
    return ret;
    }
}

class ViewController: UIViewController,SortByDel,UITextFieldDelegate {
    
    var sortBy = 0;
    var items:JSON? = nil
    
    
    //@IBOutlet var flasher: UIActivityIndicatorView!
    @IBOutlet var blur: UIVisualEffectView!
    @IBOutlet weak var warn: UILabel!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var txtKey: UITextField!
    @IBOutlet weak var txtMin: UITextField!
    @IBOutlet weak var txtMax: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //flasher.hidden = true;
        blur.hidden = true;
        // Do any additional setup after loading the view, typically from a nib.
        
        //dismiss keyboard when necessary
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        txtKey.delegate = self;
        txtMin.delegate = self;
        txtMax.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "showSort" {
            let cv:sortByVC = segue!.destinationViewController as! sortByVC;
            cv.del = self;
        }
        else if segue!.identifier == "showResult"{
            //pass json data to second view
            let cv:resultView = segue!.destinationViewController as! resultView;
            cv.items = items;
            cv.keywords = txtKey.text;
        }
        
    }
    
    //replace it with prepare for segue
   /*@IBAction func changeSort(sender: UIButton) {
        //cant use subVC = new sortByVC()...cause blank screen
        
        
        var subVC = self.storyboard?.instantiateViewControllerWithIdentifier("sortBy") as sortByVC
        subVC.del = self
        //subVC.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        subVC.view.backgroundColor =  UIColor.whiteColor()
        presentViewController(subVC, animated: true, completion: nil)

    }*/
    
    /*called by modal dialog when select is pressed*/
    func sortByFinished(controller:sortByVC, ret:Int){
        if(ret >= 0 && ret < sort.count){
            sortBy = ret;
            btnSort.setTitle(sort[ret],forState: UIControlState.Normal);
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnSearch(sender: AnyObject) {
        if let param = validate()
        {
            var url = "http://ebaysearchi-env.elasticbeanstalk.com/?f_pages=1&f_submit=submitted&f_pageCur=1"
            url += "&f_sort=\(sortBy + 1)";
            url += param;

            println("requesting from: " + url);
            
            //async loading data
            let nsurl:NSURL? = NSURL(string:url);
            if nsurl == nil {
                println("error: fail to construct NSURL");
                return;
            }
            
            //segue when succesfully get data
            //visual effect
            blur.hidden = false;
            //flasher.hidden = false;
            //flasher.startAnimating();
            view.makeToastActivity();
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(nsurl!) {
                (data, response, error) in
                
                let json = JSON(data: data);
                
                if json["ack"] == "Success" && json["resultCount"].intValue != 0{
                    println("success query");
                    dispatch_async(dispatch_get_main_queue(), {
                        self.items = json["item"];
                        //self.flasher.stopAnimating();
                        //self.flasher.hidden = true;
                        self.view.hideToastActivity();
                        self.blur.hidden = true;
                        self.performSegueWithIdentifier("showResult", sender: self)
                    });
                    
                }
                else{
                    
                    var errorNote:String! = nil;
                    if json["ack"] == "Success" || json["ack"] == "Failure"{
                        errorNote = "oops! No result found!";
                    }
                    else {
                        errorNote = "fail to fetch data T T~~~"
                    }
                    println(error);
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.makeToast(errorNote);
                        self.view.hideToastActivity();
                        //self.flasher.stopAnimating();
                        //self.flasher.hidden = true;
                        self.blur.hidden = true;
                    });
                }
                
            }
            task.resume();
            
            
            
        }
    }
    @IBAction func btnClr(sender: UIButton) {
        txtKey.text = "";
        txtMax.text = "";
        txtMin.text = "";
        warn.text = "";
        sortBy = 0;
        btnSort.setTitle(sort[0], forState: UIControlState.Normal)
    }
    
    
    /*validate keywords not empty, price should be number great than 0, price to > price from*/
    func validate() -> String?{
        var notes = "";
        var ret:String? = nil;
        
        /*remove blank space*/
        var key = join("",txtKey.text.componentsSeparatedByString(" "));
        var min = join("",txtMin.text.componentsSeparatedByString(" "));
        var max = join("",txtMax.text.componentsSeparatedByString(" "));
        
        
        if(key == ""){
            notes = "Please enter keywords";
            ret = nil;
        }
        else{
            ret = "&f_key=" + key;
        }
        
        if(ret != nil && (!min.isFloat() && min != "")){
            notes = "Price From should be number greater than 0";
            ret = nil;
        }
        else if min != "" && ret != nil{
            ret! += "&f_price_min=" + min;
        }
        
        if(ret != nil && (!max.isFloat() && max != "")){
            notes = "Price To should be number greater than 0";
            ret = nil;
        }
        else if ret != nil && max != ""{
            ret! += "&f_price_max=" + max;
        }
        
        if(ret != nil  && max != "" && min != "" && min.floatValue > max.floatValue){
            notes = "Price to should be greater than price from";
            ret = nil;
        }
        warn.text = notes;
        
        return ret;
        
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        DismissKeyboard();
        return false
    }

}