//
//  myview1.swift
//  EggManager
//
//  Created by RainC on 2015. 1. 10..
//  Copyright (c) 2015년 RainC. All rights reserved.
//

import UIKit

class myview1: UIViewController {

    @IBOutlet var txtID: UITextField!
    @IBOutlet var txtPW: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func SaveSetting(sender: AnyObject) {
        var ID = txtID.text
        var PW = txtPW.text
        ViewController().egg_id = ID
        ViewController().egg_pw = PW
        
        
        
    }

 
}
