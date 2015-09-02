//
//  ViewController.swift
//  EggManager
//
//  Created by RainC on 2015. 1. 4..
//  Copyright (c) 2015년 RainC. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet var lbSignal: UILabel!
    @IBOutlet var lbIPAddress: UILabel!
    @IBOutlet var lbAPName: UILabel!
    @IBOutlet var lbBattery: UILabel!
    
    
    @IBOutlet var LoadingBar: UIActivityIndicatorView!
    
    
    var egg_id = "user" // DEFAULT USER SETTING
    var egg_pw = "0000"
    
    var device = ""
    
    let requests: [String:String] = ["Strong1": "192.168.1.254" , "Strong3" : "192.168.1.1"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var setID = ""
        var setPW = ""
        
        if (defaults.objectForKey("UserPass") != nil) {
            setID = defaults.objectForKey("UserName") as! String
            setPW = defaults.objectForKey("UserPass") as! String
        } else {
            alert("알림" , argmessage:"패스워드 설정을 먼저 해주세요.")
        }
        
        egg_id = setID
        egg_pw = setPW
        // device detect
        devicedetect()
        getInfo()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    func alert (argtitle:String, argmessage:String) {
        let alert = UIAlertController(title : argtitle , message: argmessage , preferredStyle:UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "확인", style:UIAlertActionStyle.Default, handler :nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func devicedetect() {
        var strong1_egg = "http://192.168.1.254"
        var strong3_egg = "http://192.168.1.1"
        
        var result1 = HttpRequest(string: strong1_egg, string: egg_id, string: egg_pw, string: "GET", String: "")
        var result2 = HttpRequest(string: strong3_egg, string: egg_id, string: egg_pw, string: "GET", String: "")
        
        if (result1.rangeOfString("<html>") != nil) {
            device = "Strong1"
            
        } else {
            device = "Strong3"
            
        }
       println("Seted Device : " + device)
        
    }
    func HttpRequest(string argurl:String, string id:String, string pw:String, string method:String, String parameter:String) -> String { // GET
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        
        
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let userPasswordString = id + ":" + pw
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)
        let authString = "Basic \(base64EncodedCredential)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        let session = NSURLSession(configuration: config)
        let session2 = NSURLSession(configuration: config)
        
        var running = false
        var test = ""
        var checked = false
        let url = NSURL(string: argurl)
        let url2 = NSURL(string: argurl)
        var postget = ""
        
        
        var mWork = ""
        switch method {
            case "GET":
                let task = session.dataTaskWithURL(url!) {
                    (let data, let response, let error) in
                    if let httpResponse = response as? NSHTTPURLResponse {
                        checked = true
                    }
                    let work = NSString(data: data, encoding: NSUTF8StringEncoding)
                    var response = work
                    
                    if (checked) {
                        test = response! as String
                        
                    } else {
                        test = "error"
                    }
                    running = false
                }
                running = true
                task.resume()
        
                break
            case "POST":
                let loginString = NSString(format: "%@:%@", id, pw)
                let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
                let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
                let url = NSURL(string: argurl)
                let request = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = "POST"
                request.setValue("*/*", forHTTPHeaderField: "Accept")
                request.setValue("gzip, defalte" , forHTTPHeaderField: "Accept-Encoding")
                request.setValue("ko-KR,ko;q=0.8,en-US;q=0.6;q=0.4", forHTTPHeaderField: "Accept-Language")
                request.setValue("keeo-alive", forHTTPHeaderField: "Connection")
                request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField:"Content-Type")
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                let PostString = parameter
                request.HTTPBody = PostString.dataUsingEncoding(NSUTF8StringEncoding)
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                    data, response, error in
                    if error != nil {
                        println("error=\(error)")
                        return
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    var toString = responseString! as NSString
                    mWork = toString as String
                    test = mWork as String
                    running = false
                }
                
                running = true
                task.resume()
                break
            default :
                break
            
        }
        
        var count = 0
        while running {
            println("waiting...")
            sleep(1)
            count += 1
            if (count == 5) {
                return "error"
            }
        }
        
        println(test)
        
        return test
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    func InternalProcess(string s1:String) {

        switch s1 {
            case "poweroff" :
                var work = HttpRequest(string: "http://192.168.1.254/goform/mobile_submit", string: egg_id, string: egg_pw, string: "POST", String: "pwof")
                
                if (work == "done") {
                    alert("알림", argmessage:"전원이 곧 꺼집니다.")
                } else {
                    alert("알림", argmessage:"에그랑 연결되어 있지 않습니다.")
                    println("ExceptionError : " + work)
                }
                
                break
            case "powersave":
                var work = HttpRequest(string: "http://192.168.1.254/goform/deep_sleep", string: egg_id, string: egg_pw, string: "POST", String: "dummy=")
                if (work.rangeOfString("JavaScript") != nil) {
                    alert("알림" , argmessage:"절전 모드로 변경됩니다.")
                } else {
                    alert("알림" , argmessage:"에그랑 연결 되어 있지 않습니다.")
                }
                break
            default :

                break
        }
    }
    
    func getInfo () {
        // Split (~)
        // 0,signal strength
        // 1,battery
        // 2,version
        // 3,ssid
        // 4,WiBro IP
        // 5,WiBro Use Time
        // 6,WiBro MAC
        // 7,secu mode
        // 8,wifi mac
        // 9,wifi list
        // 10,curStaNum
        // 11,maxStaNum
        // 12,lan ip
        // 13,dhcp start
        // 14,dhcp end
        // 15,dhcp list
        // 16,WiBro GW
        var Info = "none"
        switch device {
            case "Strong1":
                Info = HttpRequest(string: "http://192.168.1.254/goform/get_mobile_info", string: egg_id, string: egg_pw, string: "POST", String: "n/a")
                break
            case "Strong3":
                Info = HttpRequest(string: "http://192.168.1.1/goform/get_mobile_info", string: egg_id, string: egg_pw, string: "POST", String: "n/a")
                break
            default :
                break
            
        }
        
        if (Info.rangeOfString("Access") != nil) {
            alert("알림", argmessage:"패스워드가 일치하지 않습니다. 사용자 재설정이 필요합니다.")
        } else {
            if (Info == "error") {
                alert("Error", argmessage:"기기와 연결되어 있지 않습니다.")
                println("Egg ID : " + egg_id + " , EggPW : " + egg_pw)
                
            } else { // case by seperate method
                var seperate = split(Info) {$0 == "~"}
                var APName = ""
                var IPAddress = ""
                var Signal = ""
                var Battery = ""
                switch device {
                    case "Strong3":
                        Signal = seperate[0]
                        Battery = seperate[1]
                        lbAPName.text = "지원 예정"
                        lbIPAddress.text = "지원 예정"
                        lbSignal.text = Signal
                        lbBattery.text = Battery + "%"
                        break
                    case "Strong1":
                        APName = seperate[3]
                        IPAddress = seperate[4]
                        Signal = seperate[0]
                        Battery = seperate[1]
                        lbAPName.text = APName
                        lbIPAddress.text = IPAddress
                        lbSignal.text = Signal
                        lbBattery.text = Battery + "/" + "5"
                        break
                    default :
                        break
                }
                
                
                
            }
        }
        
    
    
    }
    
    
   
    
    func parse (string response:String) ->String{
        
        return "parse"
        
    }
    
   
    @IBAction func Reload(sender: AnyObject) {
        getInfo()
    }
    
    
    @IBAction func PowerOff(sender: AnyObject) {
        InternalProcess(string: "poweroff")
    }
    
    @IBAction func PowerSave(sender: AnyObject) {
        InternalProcess(string: "powersave")
    }
   
    
   
}

