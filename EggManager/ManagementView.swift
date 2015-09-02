//
//  ManagementView.swift
//  EggManager
//
//  Created by RainC on 2015. 1. 16..
//  Copyright (c) 2015년 RainC. All rights reserved.
//

import UIKit

class ManagementView: UIViewController {

    @IBOutlet weak var txtid: UITextField!
    @IBOutlet weak var txtpw: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var setID = ""
        if (defaults.objectForKey("UserName") != nil) {
            setID = defaults.objectForKey("UserName") as! String
        } else {
            
        }
        txtid.text = setID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func SetIDPW(string ID:String , string PW:String) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(ID, forKey: "UserName")
        defaults.setObject(PW, forKey: "UserPass")
        defaults.synchronize()
        
    }
    @IBAction func reset(sender: UIButton) {
        SetIDPW(string: txtid.text, string: txtpw.text)
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var setID = defaults.objectForKey("UserName") as! String
        var setPW = defaults.objectForKey("UserPass") as! String
        
        println("ID : \(setID ) , PW : \(setPW)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
