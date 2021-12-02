//
//  basicNewConversationViewController.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class basicNewConversationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    //var db:Firestore!
    let db = Firestore.firestore()
    
    func enterNewChat(uID:String ,userName:String,profileImage:String){
        
        //globalUserID = uID
        //activeConversationID
        activeConversationID = uID
        activeConversation = userName
        
        db.collection("users/\(activeConversationID)/CHATS/").document("\(globalUserID!)").setData([
            "nickname": "\(globalUserName)",
            "profileimage": "\(globalProfileImage)",
            "lastMessage": "feature not available yet!"
        ]) { err in
            if let err = err {
                print("Error creating new chat on other side: \(err)")
            } else {
                print("New chat created on other side (1/2)!")
            }
        }
        
        db.collection("users/\(globalUserID!)/CHATS/").document("\(activeConversationID)").setData([
            "nickname": "\(userName)",
            "profileimage": "\(profileImage)",
            "lastMessage": "feature not available yet!"
        ]) { err in
            if let err = err {
                print("Error creating chat on your side: \(err)")
            } else {
                print("New chat created on your side! (2/2)")
                self.performSegue(withIdentifier: "enter chat", sender: nil)
            }
        }
        
        
        
    }
    
    @IBAction func enterPress(_ sender: Any) {
        let nume = String(nameTextField.text ?? "errorr")
        errorLabel.isHidden = true
        errorLabel.text = "\(nume) does not exist"
        print("looking for: \(nume)")
        
        var k=0
        
        db.collection("users/").whereField("username", isEqualTo: nume).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self.errorLabel.isHidden = false
            } else {
                for document in querySnapshot!.documents {
                    k=k+1
                    //index = index+1
                    //print(index)
                    //print("\(document.documentID) => \(document.data())")
                    if(k==1){
                    let docdata = document.data() as [String : Any]
                    let nameVar = docdata["username"] as? String ?? "error"
                    let userID = document.documentID
                    let profileImage = docdata["profileimage"] as? String ?? "error"
                    print("FIRST RESULT IS: \(nameVar) with id \(userID)")
                        
                    self.enterNewChat(uID: userID, userName: nameVar, profileImage: profileImage)
                        
                    }
            }
                if(k==0){
                    self.errorLabel.isHidden = false
                }
            }
        
        //let usersRef = db.collection("users")
        //let query = usersRef.whereField("username", isEqualTo: nume ?? "empty")
        
        //print(query)
        
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
