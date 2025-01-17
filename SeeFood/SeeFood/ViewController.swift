//
//  ViewController.swift
//  SeeFood
//
//  Created by luis salazar on 12/20/18.
//  Copyright © 2018 F Productions. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        //implementing camera property
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage.")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        // try? is attempting to perform the operation. If it doesn't succed, it returns nil.
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model failed.")
        }
        
        let request = VNCoreMLRequest(model: model) {  (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
//            let dogArray = [
//                "german sheperd",
//                "golden retriever",
//                "chihuahua",
//                "retriever",
//                "buldog",
//                "terrier",
//                "corgi",
//                "maltese",
//                "belgian shepherd",
//                "dutch shepherd",
//                "labradoodle",
//                "labrador retriever",
//                "siberian husky",
//                "alaskan malamute",
//                "rottweiler",
//                "border collie",
//                "australian shepherd",
//                "dog"
//            ]
            
            print(results.first)
            if let firstResult = results.first {
                if firstResult.identifier.contains("German shepherd") {
                    self.navigationItem.title = "It is a german sheperd!"
                }
                else if firstResult.identifier.contains("Golden retriever") {
                    self.navigationItem.title = "It is a golden retriever!"
                }
                else if firstResult.identifier.contains("Chihuahua") {
                    self.navigationItem.title = "It is a chihuahua!"
                }
                else if firstResult.identifier.contains("Border collie") {
                    self.navigationItem.title = "It is a border collie!"
                }
                else if firstResult.identifier.contains("Labrador retriever") {
                    self.navigationItem.title = "It is a labrador retriever!"
                }
                else {
                    self.navigationItem.title = "It is not a doggy!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

