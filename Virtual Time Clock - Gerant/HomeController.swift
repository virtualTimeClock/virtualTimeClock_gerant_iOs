//
//  loginToHome.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 10/31/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI




class HomeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: Outlet
    
    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var capture: UIButton!
    
    // MARK: Attributs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    private func setup(){
        capture.layer.cornerRadius = 20
        img.layer.borderWidth = 10
        //let color = UIColor(rgb: 0xD84E21)
        img.layer.borderColor = UIColor.orange.cgColor
        
    }
    
    // MARK: Action
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func captureAndSave(_ sender: Any) {
        
    
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //let image = info[UIImagePickerController.InfoKey.cropRect] as! UIImage
        
        img.image = image
        
        
        //Lien avec l'espace de stockage du serveur Firebase
        let storage = Storage.storage()
        //Creation de la reference de l'image (chemin d'acces)
        let imagesRef = storage.reference().child("Photos/profilePic")
        
        //création des metadata avec le type de la ressource
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        
        
        //mise en memoire sous forme de data
        if let uploadData = self.img.image!.jpegData(compressionQuality: 0.75) {
        
            //upload l'image sur la base
            imagesRef.putData(uploadData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    print("error")
                    
                } else {
                    print("Image Upload sur le serveur")
                    
                }
           }
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    }
    
}

