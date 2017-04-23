//
//  ScheduleViewController.swift
//  Success
//
//  Created by Maathusan Rajendram on 2017-04-16.
//  Copyright © 2017 Maathusan Rajendram. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var userGoal_Lbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var todo_textField: UITextView!
    
    struct defaultsKeys {
        static let key_userGoal = "userGoal"
        static let key_dailyTODO = "dailyTODO"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todo_textField.delegate = self
        self.scrollView.delegate = self
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ScheduleViewController.keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ScheduleViewController.keyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "My Schedule"
        
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.key_userGoal) {
            userGoal_Lbl.text = stringOne
        }
        if let stringTwo = defaults.string(forKey: defaultsKeys.key_dailyTODO) {
            todo_textField.text = stringTwo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let defaults = UserDefaults.standard
        defaults.set(textView.text, forKey: defaultsKeys.key_dailyTODO)
        print("TODO: " + textView.text)
    }
    
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    func keyboardWillShow(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification)
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
