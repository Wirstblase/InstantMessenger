//
//  chatCameraViewController.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class chatCameraViewController: UIViewController{
    
    //var db:Firestore!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var takenPictureView: UIView!
    @IBOutlet weak var sendPhotoBtn: UIButton!
    
    @IBOutlet weak var takenPicturePictureView: UIImageView!
    
    let storage = Storage.storage()
    
    @IBAction func xButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadPicture(){
        let storageRef = storage.reference()
        // Local file you want to upload
        let localFile = URL(string: "path/to/image")!
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }

    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    // Declaring a camera preview layer
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    let captureSession = AVCaptureSession()
    
    @IBOutlet var cameraButton:UIButton!
    
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage: UIImage?
    
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 15
        deleteBtn.layer.cornerRadius = 15
        xButton.layer.cornerRadius = 15
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Configure the sesson with the output for capturing still images
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        let devices = AVCaptureDevice.devices(for: AVMediaType.video) as! [AVCaptureDevice]
        
        // Preset the session for taking photo in full resolution
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // Adding the Zoom Recognizer function
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
        
        // Get the front and back-facing camera for taking photos
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backFacingCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontFacingCamera = device
            }
        }
        currentDevice = backFacingCamera
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(stillImageOutput!)
            
        } catch {
            print (error)
        }
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        // Bring the camera button to front
        view.bringSubviewToFront(takenPictureView)
        view.bringSubviewToFront(cameraButton)
        view.bringSubviewToFront(xButton)
        captureSession.startRunning()
        
        // Side note: at some point use AVLayerVideoGravityResize & AVLayerVideoGravityResizeAspect for square images
        
        // Toggle Camera recognizer
        toggleCameraGestureRecognizer.direction = .up
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(toggleCamera))
        view.addGestureRecognizer(toggleCameraGestureRecognizer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action methods
    //var imageToBeSent:UIImage
    
    func imageWithPixelSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, opaque: Bool = false) -> UIImage {
        return imageWithSize(size: size, filledWithColor: color, scale: 1.0, opaque: opaque)
    }
    func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    var imageToBeSent: UIImage? = nil
    
    @IBAction func capture(sender: UIButton) {
        
        let videoConnection = (stillImageOutput?.connection(with: AVMediaType.video))!
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            
            if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!) {
                self.stillImage = UIImage(data: imageData)
                //self.performSegue(withIdentifier: "showPhoto", sender: self)
                self.takenPicturePictureView.image = self.stillImage
                self.takenPictureView.isHidden = false
                self.cameraButton.isHidden = true
                
                self.deleteBtn.isEnabled = true
                self.saveBtn.isEnabled = true
                self.xButton.isHidden = true
                
                self.sendPhotoBtn.layer.cornerRadius = 20
                self.sendPhotoBtn.isHidden = false
                
                self.imageToBeSent = self.stillImage!
            }
        })
    }
    // MARK: - Toggle Camera
    
    let db = Firestore.firestore()
    
    func sendPhoto(PHOTOURL: String){
        
        let dataString = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        var ref: DocumentReference? = nil
        ref = db.collection("users/\(globalUserID!)/CHATS/\(activeConversationID)/CHAT/").addDocument(data: [
            "type": 0,
            "contentType": 2,
            "content" : PHOTOURL ,
            "data" : dataString,
            "readStatus" : false,
            "sender" : String(globalUserID ?? "error")
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        ref = db.collection("users/\(activeConversationID)/CHATS/\(globalUserID!)/CHAT/").addDocument(data: [
            "type": 0,
            "contentType": 2,
            "content" : PHOTOURL ,
            "data" : dataString,
            "readStatus" : false,
            "sender" : String(globalUserID ?? "error")
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        //Update()
        
    }
    
    func sendFullRes(dateString: String){
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        // 1 Media Data in memory
        var data = Data()
        
        data = (imageToBeSent?.jpegData(compressionQuality: 5))!
        
        // 2 Create a reference to the file you want to upload
        let pozaRef = storageRef.child("users/\(globalUserID!)/\(activeConversationID)/poza\(dateString).jpg")
        
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
                
                
                //self.sendPhoto(PHOTOURL: imgurlString)
                self.sendPhoto(PHOTOURL: "users/\(globalUserID!)/\(activeConversationID)/poza\(dateString).jpg")
                
                
            })
        }
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
    
    func sendLowRes(dateString: String){
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        // 1 Media Data in memory
        var data = Data()
        
        let imageResized = resizeImage(image: imageToBeSent!, newWidth: 200)
        
        if let imageData = imageResized.jpeg(.lowest) {
            print(imageData.count)
            data = imageData
        }
        
        /*let compressData = UIImageJPEGRepresentation(imageResized!, 0.5) //max value is 1.0 and minimum is 0.0
        let compressedImage = UIImage(data: compressData!)*/
        
        //data = (imageResized.jpegData(compressionQuality: 5))!
        
        
        // 2 Create a reference to the file you want to upload
        let pozaRef = storageRef.child("users/\(globalUserID!)/\(activeConversationID)/poza\(dateString)LOWRES.jpg")
        
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
                
                
                //self.sendPhoto(PHOTOURL: imgurlString)
                //self.sendPhoto(PHOTOURL: "users/\(globalUserID!)/\(activeConversationID)/poza\(dateString).jpg")
                
                
            })
        }
    }
    
    @IBAction func deleteBtnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPress(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(imageToBeSent!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        saveBtn.setTitle("saved", for: .normal)
        deleteBtn.setTitle("cancel", for: .normal)
        saveBtn.isEnabled = false
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
    
    @IBAction func sendPhoto(_ sender: Any) {
        
        
        let date = Date()
        let dateString = date.description
        
        sendLowRes(dateString: dateString)
        sendFullRes(dateString: dateString)
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func toggleCamera() {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontFacingCamera : backFacingCamera
        
        // Remove all inputs from the session
        
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
            
        } catch {
            print(error)
            return
        }
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
        
    }
    
    // MARK: - Zoom function
    
    @objc func zoomIn() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor < 10.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 10.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                    
                }
            }
        }
    }
    @objc func zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Segues
    
    //@IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
        
    //}
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view conrtoller using segue.destinationViewController
        // Pass the selected object to the new view controller
        
        if segue.identifier == "showPhoto" {
            
            let photoViewController = segue.destination as! PhotoViewController
            photoViewController.image = stillImage
            
            
        }
    }*/
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
