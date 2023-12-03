//
//  UploadViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let fireStore = Firestore.firestore()
    let instance = UserSingleton.sharedUserInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI(){
        imageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGesture)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        //Storage
        let storageReference = Storage.storage().reference()
        let mediaFoler = storageReference.child("Media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFoler.child("\(uuid).jpg")
            imageReference.putData(data) { metaData, error in
                if let error = error {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            if let imageUrl = url?.absoluteString {
                                
                                //Firestore
                                self.fireStore.collection("Snaps").whereField("email", isEqualTo: self.instance.email).getDocuments { snapshot, error in
                                    if let error = error {
                                        self.makeAlert(title: "Error", message: error.localizedDescription)
                                    } else {
                                        if snapshot != nil && snapshot?.isEmpty == false {
                                            for document in snapshot!.documents {
                                                if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                    imageUrlArray.append(imageUrl)
                                                    let additionalDictionary = ["imageUrlArray": imageUrlArray]
                                                    let documentId = document.documentID
                                                    self.fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                        if let error = error {
                                                            self.makeAlert(title: "Error", message: error.localizedDescription)
                                                        } else {
                                                            self.tabBarController?.selectedIndex = 0
                                                            self.imageView.image = UIImage(named: "selectImage")
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            let snapDictionary = ["imageUrlArray": [imageUrl], "name": self.instance.name, "email": self.instance.email, "date": FieldValue.serverTimestamp()] as [String: Any]
                                            self.fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                                if let error = error {
                                                    self.makeAlert(title: "Error", message: error.localizedDescription)
                                                } else {
                                                    self.tabBarController?.selectedIndex = 0
                                                    self.imageView.image = UIImage(named: "selectImage")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}
