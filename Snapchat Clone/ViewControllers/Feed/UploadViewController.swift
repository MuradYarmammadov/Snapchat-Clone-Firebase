//
//  UploadViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
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
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("images")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { metaData, error in
                if let error = error {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else{
                    imageReference.downloadURL { url, error in
                        if let error = error {
                            self.makeAlert(title: "Error", message: error.localizedDescription)
                        } else {
                            let imageUrl = url?.absoluteString
                            
                            //Firestore
                            let fireStore = Firestore.firestore()
                            fireStore.collection("Snaps").whereField("snapedBy", isEqualTo: UserSingleton.sharedUserInfo.name).getDocuments { snapshot, error in
                                if let error = error {
                                    self.makeAlert(title: "Error", message: error.localizedDescription)
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            let documentId = document.documentID
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                imageUrlArray.append(imageUrl!)
                                                let additionalArray = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                fireStore.collection("Snaps").document(documentId).setData(additionalArray, merge: true) { error in
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
                                        if let imageUrl = imageUrl{
                                            let snapDictionary = ["imageUrlArray": [imageUrl], "snapedBy": UserSingleton.sharedUserInfo.name, "date": FieldValue.serverTimestamp()] as [String: Any]
                                            fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
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
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
