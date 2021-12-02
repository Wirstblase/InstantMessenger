//
//  ChatTableViewController.swift
//  Instant
//
//  Created by Marius Suflea.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

var globalcontinut = ""
var globalcommentarray = ["", ""]

var globalUserName = ""
var globalProfileImage = ""

var runOnce = 0

var tabBarShouldBeHidden = 0


let storyColor = UIColor.init(red: 50, green: 50, blue: 255)
let noStoryColor = UIColor.init(red: 50, green: 50, blue: 50)
let seenStoryColor = UIColor.init(red: 255, green: 50, blue: 50)


func getCurrentUserInfo(){
    let db = Firestore.firestore()
    let docRef = db.collection("users/").document("\(globalUserID!)")
    
    print("currently logged in as \(globalUserID!)")
    
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            
            let docdata = document.data() as! [String : Any]
            let usrname = docdata["username"] as? String ?? "error"
            let profileimage = docdata["profileimage"] as? String ?? "error"
            
            globalUserName = usrname
            globalProfileImage = profileimage
            
            print("LOGGED IN AS: \(globalUserName) with profileImage: \(globalProfileImage)")
            
            //print("Document data: \(dataDescription)")
        } else {
            print("Error getting current logged-in user data")
        }
    }
}

let globalUserID = Auth.auth().currentUser?.uid

struct Conversation{
    var image : String
    var name : String
    var content : String
    var data : Date
    var id : String
    
    
    var dictionary:[String:Any]{
        return [
            "name" : name,
            "image" : image,
            "content" : content,
            "data" : data,
            "id" : id
        ]
    }
}

var activeConversation = ""
var activeConversationID = ""

class ChatTableViewController: UITableViewController {
    
    func toggleTabbar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        let hidden = frame.origin.y == view.frame.size.height
        frame.origin.y = hidden ? view.frame.size.height - frame.size.height : view.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }
    
    var conversationArray = [Conversation]()
    
    @IBAction func newChat(_ sender: Any) {
        
        
        
    }
    
    var db:Firestore!
    
    
    /*func getData(id: String){
        
        
        let docRef = self.db.collection("users").document("\(id)")
        
        
        docRef.getDocument { (document1, error) in
            if let document1 = document1, document1.exists {
                
                let doccdata = document1.data() as! [String: Any]
                
                self.nameVar = doccdata["username"] as? String ?? ""
                self.imageVar = doccdata["profileimage"] as? String ?? ""
                
                print("IMAGEVAR")
                print(self.imageVar)
                print("NAMEVAR")
                print(self.nameVar)
                
                
                //print("Document data!!: \(dataDescription)")
            } else {
                print("ERROR ERROR ERROR!!")
            }
        }
    }*/
    func sortMessages(){
        
        if(conversationArray.count > 1) {
            
            conversationArray = conversationArray.sorted(by: {
                $0.data.compare($1.data) == .orderedDescending
            })
            
            //var messageArray2 = messageArray
            //print("DATES:")
            //for x in conversationArray{
            //    print(x.data)
                
            //}
            
        }
        
        
    }
    
    func Update(){
        
    
        db.collection("users/\(globalUserID!)/CHATS")/*.whereField("", isEqualTo: true)*/.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var index = 0
                    
                    for document in querySnapshot!.documents {
                        index = index+1
                        print(index)
                        
                        
                        let docdata = document.data() as [String : Any]
                        let contentVar = docdata["lastMessage"] as? String ?? ""
                        let nameVar = docdata["nickname"] as? String ?? ""
                        let imageVar = docdata["profileimage"] as? String ?? ""
                        let lastMessageDateVar = docdata["lastMessageDate"] as? String ?? ""
    
                        self.conversationArray.append(Conversation( image: imageVar, name: nameVar,content: contentVar,data: lastMessageDateVar.toDate() ?? Date(), id: document.documentID ))
                        //print(self.conversationArray)
                        
                        //self.conversationArray[index].name = docdata["name"] as? String ?? ""
                        
                        self.sortMessages()
                        self.tableView.reloadData()
                        
                    }
                    
                    
                   
                }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(runOnce == 0){
            getCurrentUserInfo()
            runOnce = runOnce+1
        }
        
        db = Firestore.firestore()
        
        
        
        //conversationArray.append(Conversation( image: "image", name: "TEST",content: "content",data: Date() ))
        //conversationArray.append(Conversation( image: "image", name: "TEST2",content: "content",data: Date() ))
        
        tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        conversationArray = [Conversation]()
        
        Update()
        
        sortMessages()
        
        self.tableView.reloadData()
        //self.tabBarController?.tabBar.isHidden = false
        
        
        /*UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController?.tabBar.layer.zPosition = 0
        })*/
        //showTabBar()
        if(tabBarShouldBeHidden == 1){
            //self.tabBarController?.tabBar.layer.zPosition = 0
            self.tabBarController?.tabBar.isHidden = false
            toggleTabbar()
            tabBarShouldBeHidden = 0
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationArray.count
    }
    
    override func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            
            let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
            let deleteAction = UITableViewRowAction(style: .destructive,
                                                    title: deleteTitle) { (action, indexPath) in
                                                        /*self.tableView.delete(indexPath)*/
                                                print("deleteaction")
            }
            
            
            
            //favoriteAction.backgroundColor = .green
            return [deleteAction]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        let message = conversationArray[indexPath.row]
        //cell.usernamelabel.text = post.name
        cell.cellNameLabel.text = message.name
        cell.cellLastMessageLbl.text = message.content
        let url = NSURL(string: message.image)
        cell.cellImageView.load(url: url! as URL)
        cell.cellImageViewView.layer.cornerRadius = 30
        cell.cellImageView.layer.cornerRadius = 28.5
        cell.cellView.layer.cornerRadius = 20
        
        //cell.cellImageViewView.backgroundColor = storyColor
        
        cell.cellImageView.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
        
        //cell.cellImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("selected")
        
        
        
        
        /*UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController?.tabBar.layer.zPosition = -1
        })
        
        self.tabBarController?.tabBar.isHidden = true*/
        //hideTabBar()
        
        toggleTabbar()
        tabBarShouldBeHidden = 1
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isHidden = true
        
        
        activeConversation = conversationArray[indexPath.row].name
        activeConversationID = conversationArray[indexPath.row].id
        print (activeConversation)
        
        performSegue(withIdentifier: "enterConvo", sender: self)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension UIViewController {
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.5) {
        if self.tabBarController?.tabBar.isHidden != hidden{
            if animated {
                //Show the tabbar before the animation in case it has to appear
                if (self.tabBarController?.tabBar.isHidden)!{
                    self.tabBarController?.tabBar.isHidden = hidden
                }
                if let frame = self.tabBarController?.tabBar.frame {
                    let factor: CGFloat = hidden ? 1 : -1
                    let y = frame.origin.y + (frame.size.height * factor)
                    UIView.animate(withDuration: duration, animations: {
                        self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                    }) { (bool) in
                        //hide the tabbar after the animation in case ti has to be hidden
                        if (!(self.tabBarController?.tabBar.isHidden)!){
                            self.tabBarController?.tabBar.isHidden = hidden
                        }
                    }
                }
            }
        }
}
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}
