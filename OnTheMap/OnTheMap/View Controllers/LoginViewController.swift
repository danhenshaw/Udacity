//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit
import Foundation

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    
    var keyboardOnScreen = false
    
    // OUTLETS
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        activityIndicator.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // LOGIN BUTTON
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        if usernameTextField.text == "" && passwordTextField.text == "" {
            createAlert(self, error: Constants.errorStrings.noIDAndPassword)
            self.usernameTextField.becomeFirstResponder()
        }else if
            usernameTextField.text == "" {
            createAlert(self, error: Constants.errorStrings.noID)
            self.usernameTextField.becomeFirstResponder()
        }else if
            passwordTextField.text == "" {
            createAlert(self, error: Constants.errorStrings.noPassword)
            self.passwordTextField.becomeFirstResponder()
        } else {
            Constants.LoginData.username = usernameTextField.text!
            Constants.LoginData.password = passwordTextField.text!
            
            startAnimatingActivityIndicator()
            
            UdacityClient.sharedInstance().authenticateWithViewController(usernameTextField.text!, password: passwordTextField.text!) { (success, errorString) in
                performUpdatesOnMain {
                    
                    if success {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(controller!, animated: true, completion: nil)
                        self.stopAnimatingActivityIndicator()
                        print("login successful")
                        
                    } else {
                        
                        performUpdatesOnMain {
                        self.stopAnimatingActivityIndicator()
                        createAlert(self, error: errorString!)
                            
                        }
                    }
                }
            }
        }
    }
    
    // SING UP BUTTON REDIRECTS YOU TO UDACITY SIGN UP PAGE
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")! as URL, options: [:], completionHandler: nil)
    }    
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

// ACTIVTY INDICATOR

private extension LoginViewController {
    
    func startAnimatingActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.alpha = 1.0
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func stopAnimatingActivityIndicator() {
        activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0.0
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

