//
//  LoginViewController.swift
//  Moview
//
//  Created by admin on 03/07/2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func loginClicked(_ sender: Any) {
        if (isFormValid()) {
            self.loading.isHidden = false
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { user, error in 
                if let error = error {
                    if [AuthErrorCode.networkError, AuthErrorCode.wrongPassword, AuthErrorCode.userNotFound, AuthErrorCode.invalidEmail].contains(AuthErrorCode(rawValue: error._code)){
                        self.displayAlert(message: error.localizedDescription)
                    }
                    else {
                        self.displayAlert(message: "An Error occured. Please try again later")
                    }
                }
                else {
                    // user is signed in
                    self.performSegue(withIdentifier: "toHomeSegue", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let firebaseAuth = Auth.auth()
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//          print("Error signing out: %@", signOutError)
//        }

        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toHomeSegue", sender: self)
        }
        else {
            //self.loading.isHidden = true
        }
    }
    
    @IBAction func backToLogin(segue: UIStoryboardSegue) {}
    
    func isFormValid() -> Bool {
        if ((emailText.text?.isEmpty ?? true) || (passwordText.text?.isEmpty ?? true)) {
            displayAlert(message: "Please fill all fields")
            return false
        }
        
        return true
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
