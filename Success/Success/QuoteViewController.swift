//
//  QuoteViewController.swift
//  Success
//
//  Created by Maathusan Rajendram on 2017-04-09.
//  Copyright © 2017 Maathusan Rajendram. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    struct defaultsKeys {
        static let keyOne = "firstStringKey"
        static let keyTwo = "secondStringKey"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Quote");
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let stringOne = defaults.stringForKey(defaultsKeys.keyOne) {
            textField.text = stringOne
            //print(stringOne)
        }
        
        let url : String = "http://apimk.com/motivationalquotes?get_quote=yes" //"http://www.fantasyfootballnerd.com/service/nfl-teams/json/test/"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        print("Start")
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            do {
                let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
                print("In method")
                if (jsonResult != nil) {
                    // process jsonResult
                    print("Data added")
                    print(jsonResult)
                    
                    let firstQuote = jsonResult![0] as? NSDictionary
                    print(firstQuote)
                    let quote = firstQuote!["quote"] as? String
                    let author = firstQuote!["author_name"] as? String
                    
                    //self.textView.text = quote! + " - " + author!
                    print(quote! + " - " + author!)
                    // Teams Ex.
//                    let teams = jsonResult["NFLTeams"] as? NSArray
//                    print(teams)
//                    let team = teams![0] as? NSDictionary
//                    print(team)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldChanged(sender: UITextField) {
        print(textField.text)
        
        saveGoal(textField.text!)
    }

    func saveGoal(goal: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(goal, forKey: defaultsKeys.keyOne)
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

}
