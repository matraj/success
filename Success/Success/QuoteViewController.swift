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
        static let key_dailyQuote = "dailyQuote"
        static let key_quoteCounter = "quoteCounter"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Quote");
        
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.key_userGoal) {
            userGoal_Lbl.text = stringOne
            //print(stringOne)
        }
        
        self.fetchQuote()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.tabBarController?.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.tabBarController?.view.addGestureRecognizer(swipeLeft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
//                print("Swiped right")
                self.tabBarController?.selectedIndex -= 1
            case UISwipeGestureRecognizerDirection.left:
//                print("Swiped left")
                self.tabBarController?.selectedIndex += 1
            default:
                break
            }
        }
    }
    
    func setupUI() {
        self.tabBarController?.navigationItem.title = "Daily Quote"
        
        // Fill goal banner
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.key_userGoal) {
            userGoal_Lbl.text = stringOne
        }
        
        // Add settings button
        let settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        settingButton.setBackgroundImage(UIImage(named: "setting_icon"), for: UIControlState())
        settingButton.addTarget(self, action: #selector(QuoteViewController.segueToSetting), for: .touchUpInside)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }
    
    func segueToSetting() {
//        performSegueWithIdentifier("toSettings", sender: nil)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "settingVC") as! SettingsViewController
        
//        self.tabBarController?.navigationController?.pushViewController(nextViewController, animated: true)
        self.tabBarController?.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    func fetchQuote() {
        
        // Gets int for today (integer will cycle every 365 days)
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        let index = components.day
        
        var todayInt = 0
        
        // Gets int of the day previously saved
        let defaults = UserDefaults.standard
        if defaults.string(forKey: defaultsKeys.key_quoteCounter) != nil {
            todayInt = Int(defaults.string(forKey: defaultsKeys.key_quoteCounter)!)!
        }
        
        print("Todays Int: \(todayInt) vs. Previously saved: \(String(describing: index))")
        
        if index != todayInt {
            
            // Save todays int as the most recent & fetch new quote
            defaults.set(index, forKey: defaultsKeys.key_quoteCounter)
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                // Make async API call to fetch quote & image
                self.getQuote("http://apimk.com/motivationalquotes?get_quote=yes")
                
                DispatchQueue.main.async {
                    //loading sign
                    self.textView.text = "Loading..."
                }
            }
        } else {
            
            // Show same quote as it is not a new day
            let dailyQuote = defaults.string(forKey: defaultsKeys.key_dailyQuote)
            self.textView.text = dailyQuote
        }

    }
    
    func getQuote(_ reuqestUrl: String){
        let url : String = reuqestUrl
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: url)
        request.httpMethod = "GET"
        print("Start")
        
        let session = URLSession.shared
        var firstQuote = [String: AnyObject]()
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let jsonResult: NSArray! = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                print("In method")
                if (jsonResult != nil) {
                    // process jsonResult
                    print("Data added")
                    print(jsonResult)
                    
                    firstQuote = (jsonResult![0] as? [String: AnyObject])!
//                    print(firstQuote)
                    let quote = firstQuote["quote"] as? String
                    let author = firstQuote["author_name"] as? String
                    
                    DispatchQueue.main.async {
                        
                        let dailyQuote = quote! + " - " + author!
                        
                        let defaults = UserDefaults.standard
                        defaults.set(dailyQuote, forKey: defaultsKeys.key_dailyQuote)
                        
                        self.textView.text = dailyQuote
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
        }) .resume()
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
