//
//  loginViewController.swift
//  Instant
//
//  Created by Marius Suflea.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func sendEmailVerification(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            callback?(error)
        })
    }
    
    func reloadUser(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
}

class loginViewController: UIViewController {
    
    var failed = true
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorTextView: UITextView!
    
    func addNewUserDefaultData(newName: String,newUID: String){
        let db = Firestore.firestore()
        
        
        db.collection("users/").document("\(newUID)").setData([
            "username": "\(newName)",
            "profileimage": "https://firebasestorage.googleapis.com/v0/b/instant-263.appspot.com/o/profilePictures%2Fthumbnail1.png?alt=media&token=87b59c62-2489-4c3b-b8ab-cf14c564a743"
        ]) { err in
            if let err = err {
                print("Error adding data for new user \(err)")
            } else {
                print("new user created AND default data ADDED")
            }
        }
        
    }
    
    @IBAction func signupbuttontap(_ sender: Any) {
        
        let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created."
                    let newName = self.usernameTextField.text ?? "error"
                    let newID = Auth.auth().currentUser?.uid ?? "error"
                    print("new username will be called: \(newName) and will have the ID: \(newID)")
                    self.addNewUserDefaultData(newName: newName, newUID: newID)
                    self.performSegue(withIdentifier: "proceed", sender: self)
                } else {
                    message = "You've entered something wrong"
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
            }
        }
        
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameView.layer.cornerRadius = 20
        emailView.layer.cornerRadius = 20
        passwordView.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
