//
//  QuoteViewController.swift
//  Success
//
//  Created by Maathusan Rajendram on 2017-04-09.
//  Copyright © 2017 Maathusan Rajendram. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userGoal_Lbl: UILabel!
    
    struct defaultsKeys {
        static let key_userGoal = "userGoal"
        static let keyOne = "firstStringKey"
        static let keyTwo = "secondStringKey"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Quote");
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let stringOne = defaults.stringForKey(defaultsKeys.key_userGoal) {
            userGoal_Lbl.text = stringOne
            //print(stringOne)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            // Make async API call to fetch quote & image
            self.getQuote("http://apimk.com/motivationalquotes?get_quote=yes")

            dispatch_async(dispatch_get_main_queue()) {
                //loading sign
                self.textView.text = "Loading..."
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Daily Quote"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let stringOne = defaults.stringForKey(defaultsKeys.key_userGoal) {
            userGoal_Lbl.text = stringOne
        }
        
        let settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        settingButton.setBackgroundImage(UIImage(named: "setting_icon"), forState: UIControlState.Normal)
        settingButton.addTarget(self, action: #selector(QuoteViewController.segueToSetting), forControlEvents: .TouchUpInside)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }
    
    func segueToSetting() {
//        performSegueWithIdentifier("toSettings", sender: nil)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("settingVC") as! SettingsViewController
        
        self.tabBarController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func getQuote(reuqestUrl: String){
        let url : String = reuqestUrl
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        print("Start")
        
        let session = NSURLSession.sharedSession()
        var firstQuote = [String: AnyObject]()
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
                print("In method")
                if (jsonResult != nil) {
                    // process jsonResult
                    print("Data added")
                    print(jsonResult)
                    
                    firstQuote = (jsonResult![0] as? [String: AnyObject])!
//                    print(firstQuote)
                    let quote = firstQuote["quote"] as? String
                    let author = firstQuote["author_name"] as? String
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.textView.text = quote! + " - " + author!
                    }
                    
                    // Teams Ex.
                    //                    let teams = jsonResult["NFLTeams"] as? NSArray
                    //                    let team = teams![0] as? NSDictionary
                    //                    let shortN = team!["shortName"] as? String
                    //                    print(shortN)
                    
                } else {
                    print("No Data")
                    // couldn't load JSON, look at error
                }
            }
            catch {
                print("Error Occured")
            }
        }.resume()
    }
    
    
//    func getJsonData() throws {
//        let urlPath = "http://myserver/myaudits"
//        let url = NSURL(string: urlPath)
//        
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url!,
//                                           completionHandler: {
//                                            data,
//                                            response,
//                                            error -> Void in
//                                            
//                                            print("Task completed")
//                                            
//                                            if(error != nil) {
//                                                print(error!.localizedDescription)
//                                            }
//                                            let err: NSError?
//                                            
//                                            let results = NSJSONSerialization.JSONObjectWithData(data!,
//                                                options: NSJSONReadingOptions.MutableContainers) as! NSArray
//                                            
//                                            if(err != nil) {
//                                                print("JSON Error \(err!.localizedDescription)")
//                                            }
//                                            
//                                            print("\(results.count) JSON rows returned and parsed into an array")
//                                            
//                                            if (results.count != 0) {
//                                                // For this example just spit out the first item "event" entry
//                                                let rowData: NSDictionary = results[0] as! NSDictionary
//                                                let deviceValue = rowData["device"] as! String;
//                                                print("Got \(deviceValue) out")
//                                            } else {
//                                                print("No rows returned")
//                                            }
//        })
//        
//        task.resume()
//        
//        //try self.Context!.save()
//    }
    
    // REST API Request
    //        var url : String = "https://apimk.com/motivationalquotes?get_quote=yes"
    //        var request : NSMutableURLRequest = NSMutableURLRequest()
    //        request.URL = NSURL(string: url)
    //        request.HTTPMethod = "GET"
    
    //
    //        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
    //            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
    //            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
    //
    //            if (jsonResult != nil) {
    //                // process jsonResult
    //            } else {
    //                // couldn't load JSON, look at error
    //            }
    //            
    //            
    //        })

}
