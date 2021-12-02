//
//  registerLoginViewController.swift
//  Instant
//
//  Created by Marius Suflea.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class registerLoginViewController: UIViewController {
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var loggedIn = false
    
    @IBOutlet weak var signUpBtnView: UIView!
    @IBOutlet weak var logInBtnView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtnView.layer.cornerRadius = 20
        logInBtnView.layer.cornerRadius = 20
        
        if Auth.auth().currentUser != nil {
            loggedIn = true
        } else {
            //User Not logged in
            self.logInBtn.isEnabled = true
            self.signUpBtn.isEnabled = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(loggedIn == true){
            self.performSegue(withIdentifier: "proceed", sender: self)
        }
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
