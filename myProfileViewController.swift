//
//  myProfileViewController.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

var editViewProfilePic = UIImage.init()
var editViewBio = ""

class myProfileViewController: UIViewController {
    
    @IBOutlet weak var friendsListView: UIView!
    
    @IBOutlet weak var myStoriesView: UIView!
    
    @IBOutlet weak var bioView: UITextView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var friendsListBtn: UIButton!
    
    @IBOutlet weak var myStoriesBtn: UIButton!
    
    let db = Firestore.firestore()
    
    func grabPic() -> UIImage {
        return profilePictureView.image!
    }
    
    func grabData(){
        let docRef = db.collection("users").document("\(globalUserID!)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                let docdata = document.data() as! [String : Any]
                let nameVar = docdata["username"] as? String ?? "error"
                let bioVar = docdata["bio"] as? String ?? "Bio not found"
                let profileImageVar = docdata["profileimage"] as? String ?? ""
                
                
                self.nameLabel.text = nameVar
                self.bioView.text = bioVar
                
                personalBioGlobal = bioVar
                
                let url = NSURL(string: profileImageVar)
                self.profilePictureView.load(url: url! as URL)
                
                editViewProfilePic = self.profilePictureView.image ?? UIImage.init()
                editViewBio = bioVar
                
                
                
                //print("Document data: \(dataDescription)")
            } else {
                //print("Document does not exist")
            }
        }
    }
    
    @IBAction func myStoriesBtnPress(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        myStoriesBtn.alpha = 1
        friendsListBtn.alpha = 0.5
        
        myStoriesView.alpha = 1
        myStoriesView.isHidden = false
        
        friendsListView.alpha = 0
        friendsListView.isHidden = true
        
        
        
    }
    
    @IBAction func friendsListBtnPress(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -130)
        })
            
        myStoriesBtn.alpha = 0.5
        friendsListBtn.alpha = 1
        
        myStoriesView.alpha = 0
        myStoriesView.isHidden = true
        
        friendsListView.alpha = 1
        friendsListView.isHidden = false
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nameLabel.text = globalUserName
        bioView.text = "loading.."
        
        grabData()
        
        //let url = NSURL(string: globalProfileImage)
        //profilePictureView.load(url: url! as URL)
        //profilePictureView.load(url: URL(fileURLWithPath: globalProfileImage))
        
        friendsListBtn.layer.cornerRadius = friendsListBtn.frame.height / 2
        myStoriesBtn.layer.cornerRadius = myStoriesBtn.frame.height / 2
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.height / 2
        
        myStoriesBtn.alpha = 1
        friendsListBtn.alpha = 0.5

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshMyStories()
    }
    
    func refreshMyStories(){
        dateArray = ["add story"]
        linkArray = [""]
        
        //cod
        
        db.collection("users/\(globalUserID!)/STORIES")/*.whereField("", isEqualTo: true)*/.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var index = 0
                
                for document in querySnapshot!.documents {
                    index = index+1
                    print(index)
                    
                    
                    let docdata = document.data() as [String : Any]
                    let dateAddedVar = docdata["dateAdded"] as? String ?? ""
                    let linkVar = docdata["link"] as? String ?? ""
                    
                    //self.conversationArray.append(Conversation( image: imageVar, name: nameVar,content: contentVar,data: lastMessageDateVar.toDate() ?? Date(), id: document.documentID ))
                    
                    self.dateArray.append(dateAddedVar)
                    self.linkArray.append(linkVar)
                    
                    //self.sortMessages()
                    //self.tableView.reloadData()
                }
                
                
                
            }
        }
        
    }
    
    var dateArray = ["add story"]
    var linkArray = [""]
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        

}
}
