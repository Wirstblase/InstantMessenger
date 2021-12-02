//
//  homeScreenViewController.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit

class homeScreenViewController: UIViewController {

    @IBOutlet weak var postButton: UIButton!
    
    
    func animatePostButton(){
        var stopPulsating = 0
        //while (stopPulsating == 0){
        
        /*UIView.animate(withDuration: 5, delay: 0, options: .curveEaseInOut, animations: {
            //self.postButton.alpha = 1
            self.postButton.backgroundColor = UIColor.white
        })*/
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
                //self.postButton.alpha = 0
                self.postButton.backgroundColor = UIColor.clear
            })
            UIView.animate(withDuration: 3, delay: 3, options: .curveEaseInOut, animations: {
                //self.postButton.alpha = 1
                self.postButton.backgroundColor = UIColor.white
            })
        //}
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.layer.cornerRadius = postButton.frame.height / 2
        
        postButton.backgroundColor = UIColor.clear
        
        //animatePostButton()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //DispatchQueue.global(qos: .background).async {
         //print("This is run on the background queue")
         animatePostButton()
         
         //}
        //animatePostButton()
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
