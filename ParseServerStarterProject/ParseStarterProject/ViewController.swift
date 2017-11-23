/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    var signupMode = true
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var signUpOrLogin: UIButton!
    @IBOutlet var changesignUpModeButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func signUpOrLogin(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" || usernameTextField.text == ""{
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
            
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode {
                
                let user = PFUser()
                
                user.username = usernameTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text

                
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil{
                        
                        var displayErrorMessage = "Please try again later"
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String{
                            
                            displayErrorMessage = errorMessage
                        
                        }
                        self.createAlert(title: "Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("user signed up")
                        
                        let current = PFUser.current()?.username
                        
                        if current != nil{
                        
                            self.performSegue(withIdentifier: "showUserTable", sender: self)
                            
                        } else {
                            
                            self.createAlert(title: "Error", message: "Sign up error")
                            
                        }
                        
                    }
                })
                
            } else {
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents() // UIApplication.shared() is now  UIApplication.shared
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                        
                        
                    } else {
                        
                        print("Logged in")
                        
                        let current = PFUser.current()?.username
                        
                        if current == nil{
                            
                            print("There's an error logging in")
                            
                        } else {
                        
                            self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                        }
                        
                    }
                    
                    
                })
            
            }
            
            
        }
        
    }
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            
            signUpOrLogin.setTitle("Log in", for: [])
            
            changesignUpModeButton.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Don't have an account?"
            
            signupMode = false
            
        } else {
            
            signUpOrLogin.setTitle("Sign up", for: [])
            
            changesignUpModeButton.setTitle("Log in", for: [])
            
            messageLabel.text = "Already have an account?"
            
            signupMode = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let current = PFUser.current()?.username
        

        
        if current != nil{
            
            performSegue(withIdentifier: "showUserTable", sender: self)
            
        } else {
        
            self.navigationController?.navigationBar.isHidden = true
        
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
            
    
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
