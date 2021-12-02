//
//  chatViewController.swift
//  Instant
//
//  Created by Marius Suflea.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit

class chatViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = activeConversation
    self.navigationController?.navigationBar.topItem?.title = activeConversation
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
