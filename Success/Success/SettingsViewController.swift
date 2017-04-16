//
//  SettingsViewController.swift
//  Success
//
//  Created by Maathusan Rajendram on 2017-04-16.
//  Copyright © 2017 Maathusan Rajendram. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var goalTextField: UITextField!
    
    struct defaultsKeys {
        static let key_userGoal = "userGoal"
        static let keyTwo = "secondStringKey"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        if let stringOne = defaults.stringForKey(defaultsKeys.key_userGoal) {
            goalTextField.text = stringOne
            //print(stringOne)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingEnded(sender: AnyObject) {
        print(goalTextField.text)
        saveGoal(goalTextField.text!)
    }

    func saveGoal(goal: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(goal, forKey: defaultsKeys.key_userGoal)
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
