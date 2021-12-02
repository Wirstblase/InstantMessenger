//
//  editProfileViewController.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

var personalBioGlobal = ""

class editProfileViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var scroll = 0
    
    @IBOutlet weak var profilePictureViewView: UIView!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var descriereView: UITextView!
    
    @IBOutlet weak var changeUsernameBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    
    func exitboii(){
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func uploadProfilePhoto(photo: UIImage) -> String {
        var link = ""
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        // 1 Media Data in memory
        var data = Data()
        
        let imageResized = resizeImage(image: photo, newWidth: 200)
        
        if let imageData = imageResized.jpeg(.lowest) {
            print(imageData.count)
            data = imageData
        }
        
        /*let compressData = UIImageJPEGRepresentation(imageResized!, 0.5) //max value is 1.0 and minimum is 0.0
         let compressedImage = UIImage(data: compressData!)*/
        
        //data = (imageResized.jpegData(compressionQuality: 5))!
        
        
        // 2 Create a reference to the file you want to upload
        let pozaRef = storageRef.child("users/\(globalUserID!)/profilePicture.jpg")
        
        // 3 Upload the file to the path "images/rivers.jpg"
        let uploadTask = pozaRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                // 4 Uh-oh, an error occurred!
                return
            }
            
            // 5
            pozaRef.downloadURL(completion: { (url, error) in
                if let error = error { return }
                // 6
                let imgurlString = "\(url!)!"
                print(imgurlString)
                link = imgurlString
                
                
                //self.sendPhoto(PHOTOURL: imgurlString)
                //self.sendPhoto(PHOTOURL: "users/\(globalUserID!)/\(activeConversationID)/poza\(dateString).jpg")
                
                
            })
        }

        
        return link
    }
    
    @IBAction func donePress(_ sender: Any) {
        
        
        if(descriereView.text != personalBioGlobal)
        {
            updatedDESC = 1
            descriptionString = descriereView.text
        }
        if(profilePictureView.image != UIImage.init())
        {
            //updatedPI = 1
            //newProfileImageString = uploadProfilePhoto(photo: profilePictureView.image!)
        }
        
        
        updateUserData()
        
        exitboii()
        
        
    }
    
    @IBAction func hideKeyboardPress(_ sender: Any) {
        if(scroll == 1){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = -200
        })
        }
    }
    
    var descriptionString = ""
    var newProfileImageString = ""
    
    var updatedPI = 0
    var updatedDESC = 0
    
    func updateUserData(){
        
        let mylastmessage = db.collection("users/").document("\(globalUserID!)")
        
        if(updatedPI == 0 && updatedDESC == 1){
            
            mylastmessage.updateData([
                "bio": descriptionString
                //"profileImage" : newProfileImageString
                
            ]) { err in
                if let err = err {
                    print("Error adding lastMessage to user: \(err)")
                } else {
                    print("added lastMessage to user")
                }
            }
            
        }
            
        else if(updatedPI == 1 && updatedDESC == 0){
            
            mylastmessage.updateData([
                //"bio": descriptionString,
                "profileImage" : newProfileImageString
                
            ]) { err in
                if let err = err {
                    print("Error adding lastMessage to user: \(err)")
                } else {
                    print("added lastMessage to user")
                }
            }
            
        }
        
        else if(updatedPI == 1 && updatedDESC == 1){

        mylastmessage.updateData([
            "bio": descriptionString,
            "profileImage" : newProfileImageString
            
        ]) { err in
            if let err = err {
                print("Error adding lastMessage to user: \(err)")
            } else {
                print("added lastMessage to user")
            }
        }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriereView.text = personalBioGlobal
        profilePictureView.image = UIImage.init()
        
        profilePictureViewView.layer.cornerRadius = profilePictureViewView.frame.height / 2
        changePasswordBtn.layer.cornerRadius = changePasswordBtn.frame.height/2
        changeUsernameBtn.layer.cornerRadius = changeUsernameBtn.frame.height/2

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //if(self.messageBar.frame.origin.y != 0){
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
                //self.messageBar.frame.origin.y -= keyboardSize.height
                scroll = 1
            }
            //if(self.messageArray.count != 0){
              //  self.tableView.scrollToBottom()
            //}
            //if self.tableView.frame.origin.y == 0{
            //self.tableView.frame.origin.y -= keyboardSize.height
            //}
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //if(self.messageBar.frame.origin.y != 0){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            //self.messageBar.frame.origin.y = 0
            scroll = 0
        }
    }

override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
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
