//
//  RegisterViewController.swift
//  Moview
//
//  Created by admin on 03/07/2021.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var selectedImage: UIImage?
    
    @IBAction func registerClicked(_ sender: Any) {
        if (isFormValid()) {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authResult, error in
                if let error = error {
                    if [AuthErrorCode.networkError, AuthErrorCode.invalidEmail, AuthErrorCode.emailAlreadyInUse].contains(AuthErrorCode(rawValue: error._code)){
                        self.displayAlert(message: error.localizedDescription)
                    }
                    else {
                        self.displayAlert(message: "An Error occured. Please try again later")
                    }
                }
                else {
                    // TODO: upload image to storage and create user in firestore
                    
                    self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set profile image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
        }
        else {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profileImage.image = selectedImage
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func isFormValid() -> Bool {
        var isValid = true
        
        checks: if selectedImage == nil {
            isValid = false
            displayAlert(message: "Please choose a profile picture")
            break checks
        }
        else if ((self.fullNameText.text?.isEmpty ?? true) || (emailText.text?.isEmpty ?? true) || (passwordText.text?.isEmpty ?? true)) {
            isValid = false
            displayAlert(message: "Please fill all fields")
            break checks
        }
        else if (passwordText.text!.count < 6) {
            isValid = false
            displayAlert(message: "Password must be at least 6 characters")
            break checks
        }
        
        return isValid
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}