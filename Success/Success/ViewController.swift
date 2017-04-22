//
//  ViewController.swift
//  Success
//
//  Created by Maathusan Rajendram on 2017-04-09.
//  Copyright © 2017 Maathusan Rajendram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    struct defaultsKeys {
//        static let keyOne = "firstStringKey"
//        static let keyTwo = "secondStringKey"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        let goalBanner = BannerView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.view.addSubview(goalBanner)
        goalBanner.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let stringOne = defaults.stringForKey(defaultsKeys.keyOne) {
//            //            print(stringOne) // Some String Value
//            let user : UserData = UserData()
//            user.goal = stringOne
//            
//            print(user.goal)
//        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
