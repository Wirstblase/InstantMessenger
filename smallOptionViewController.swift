//
//  smallOptionViewController.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//
var chatOption = 0 // 1-send photo/video

import UIKit

class smallOptionViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var sendPhotoBtnPress: UIButton!
    
    @IBAction func takePhotoPress(_ sender: Any) {
        chatOption = 2
        self.openCamera()
    }
    
    @IBAction func sendPhotoPress(_ sender: Any) {
        //takePhoto()
        chatOption = 1
        //UIViewController.unwind(activeChatTableViewController)
        //_ = navigationController?.popToRootViewController(animated: true)
        //self.dismiss(animated: true, completion: {
        //self.openCamera()
        self.openGallery()
        //})
    }
    
    //var imagePicker: UIImagePickerController!
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //imageView.contentMode = .scaleAspectFit
            //imageView.image = pickedImage
            print("YOU SHOULD SEE DA PIC")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("YO IT'S CANCELLED")
        dismiss(animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: {
            print("finished opening imagePicker")
            //self.dismiss(animated: true, completion: nil)
        })
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
