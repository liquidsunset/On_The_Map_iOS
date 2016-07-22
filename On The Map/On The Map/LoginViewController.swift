//
//  ViewController.swift
//  On The Map
//
//  Created by Daniel Brand on 20.04.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(sender: AnyObject) {
        let signUpUrl = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.sharedApplication().openURL(signUpUrl!)
    }

    @IBAction func login(sender: AnyObject) {
        guard (emailField.text != nil && !(emailField.text?.isEmpty)!) else {
            showAlertMessage("Email-Error", message: "Email field must not be empty")
            return
        }

        guard (passwordField.text != nil && !(passwordField.text?.isEmpty)!) else {
            showAlertMessage("Password-Error", message: "Password field must not be empty")
            return
        }

        UdacityClient.sharedInstance.login(emailField.text!, password: passwordField.text!) {
            (success, error) in
            guard success else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertMessage("Login Failed", message: error!)
                })
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                self.presentViewController(tabBarController, animated: true, completion: nil)
            })
        }

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

    func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(ok)

        presentViewController(alertController, animated: true, completion: nil)
    }

}

