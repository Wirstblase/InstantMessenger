//
//  registerViewController.swift
//  Instant
//
//  Created by Marius Suflea.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class registerViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBAction func loginBtnTap(_ sender: Any) {
        let loginManager = FirebaseAuthManager()
        guard let email = usernameTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                message = "User was sucessfully logged in."
                self.performSegue(withIdentifier: "proceed", sender: self)
            } else {
                message = "you've entered something wrong"
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailView.layer.cornerRadius = 20
        passwordView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
   /* func signinbuttontap(){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            // ...
        }
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
