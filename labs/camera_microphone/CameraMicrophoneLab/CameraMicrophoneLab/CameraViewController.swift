//
//  ViewController.swift
//  MicrophoneLab
//
//  Created by Xiaoxiao on 6/25/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Image view property from the storyboard.
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Take photo action from the storyboard.
    @IBAction func takePhoto(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            
            present(picker, animated: true, completion: nil)
        }
        else {
            print("Oh noes, the camera doesn't work on the simulator!")
        }
    }
    
    // Select photo action from the storyboard.
    @IBAction func selectPhoto(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            
            present(picker, animated:true, completion: nil)
        }
    }
    
    // Call this function when an image picker operation is done.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let chosenImage = info[.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
        
        // State model update.
        let model = StateModel.sharedInstance
        model.image = chosenImage
        print(model.image)
    }
    
    // Call this function when an image picker operation is cancelled.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

