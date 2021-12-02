//
//  fullscreenImageViewController.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

//var toBeSaved = UIImage.init()

class fullscreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var greenBar: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBAction func cancelpress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadLowRes(){
        /*let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        let date = Date()
        let dateString = date.description
        // 2 Create a reference to the file you want to upload
        let pozaRef = storageRef.child(globalLowResPhotoLinkDeprecated)
        
        pozaRef.downloadURL(completion: { (url, error) in
            if let error = error { return }
            // 6
            let imgurlString = "\(url!)!"
            print(imgurlString)
            
            let imageLink = url!*/
            //self.imageView.load(url: imageLink as URL)
        self.imageView.image = globalImageVariable
            
            // Do any additional setup after loading the view.
        //})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 15
        timeView.layer.cornerRadius = 15
        
        greenBar.transform = CGAffineTransform(translationX: -240, y: 0)
        
        
        
        loadLowRes()
        
    }
    @IBAction func SaveBtnPress(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func exit(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 15, animations:{ self.greenBar.transform = CGAffineTransform(translationX: 0, y: 0) }, completion: { finished in
            self.exit()
        })
        
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        let date = Date()
        let dateString = date.description
        // 2 Create a reference to the file you want to upload
        let pozaRef = storageRef.child(globalPhotoLinkDeprecated)
        
        pozaRef.downloadURL(completion: { (url, error) in
            if let error = error { return }
            // 6
            let imgurlString = "\(url!)!"
            print(imgurlString)
            
            let imageLink = url!
            self.imageView.load(url: imageLink as URL)
            //toBeSaved =
            
            // Do any additional setup after loading the view.
        })
        
        
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        
       /* let y = CGPoint(x: 10, y: 10)
        let x = gesture.velocity(in: imageView)
        if(x == y){
            self.dismiss(animated: true, completion: nil)
        }
        // 1
        let translation = gesture.translation(in: view)
        
        // 2
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        
        // 3
        
        
        if(translation.x > 100 || translation.y > 100)
        {
            //self.dismiss(animated: true, completion: nil)
            cancelpress(UIView.self)
        }
        
        gesture.setTranslation(.zero, in: view)
        /*guard gesture.state == .ended else {
            return
        }
        
        // 1
        let velocity = gesture.velocity(in: view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200
        
        // 2
        let slideFactor = 0.1 * slideMultiplier
        // 3
        var finalPoint = CGPoint(
            x: gestureView.center.x + (velocity.x * slideFactor),
            y: gestureView.center.y + (velocity.y * slideFactor)
        )
        
        // 4
        finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
        finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)
        
        // 5
        UIView.animate(
            withDuration: Double(slideFactor * 2),
            delay: 0,
            // 6
            options: .curveEaseOut,
            animations: {
                gestureView.center = finalPoint
        })*/ */
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
