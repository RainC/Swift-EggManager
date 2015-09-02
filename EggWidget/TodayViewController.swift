//
//  TodayViewController.swift
//  EggWidget
//
//  Created by RainC on 2015. 1. 16..
//  Copyright (c) 2015년 RainC. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var widgetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        
        let shareDefaults = NSUserDefaults(suiteName: "")
        
        self.widgetLabel.text = shareDefaults?.objectForKey("stringKey") as? String
        

        
        completionHandler(NCUpdateResult.NewData)
        
    }
    
}
