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
            print(stringOne)
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
