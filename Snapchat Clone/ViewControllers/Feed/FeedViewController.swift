//
//  FeedViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStore = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    let instance = UserSingleton.sharedUserInfo
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
        getDataFromFireStore()
        setTableView()
    }
    
    func getDataFromFireStore() {
        self.fireStore.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error{
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: true)
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        if let userName = document.get("name") as? String {
                            if let userEmail = document.get("email") as? String {
                                if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                    if let date = document.get("date") as? Timestamp {
                                        if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                            if difference >= 24 {
                                                self.fireStore.collection("Snaps").document(documentId).delete()
                                            } else {
                                                let snap = Snap(userName: userName, userEmail: userEmail, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                                self.snapArray.append(snap)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getUserInfo(){
        fireStore.collection("UserInfo").whereField("Email", isEqualTo: self.currentUser!.email!).getDocuments { snapshot, error in
            if let error = error {
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                if snapshot != nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        if let username = document.get("Name") as? String {
                            self.instance.email = self.currentUser!.email!
                            self.instance.name = username
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedToSnap" {
            let destination = segue.destination as! SnapViewController
            destination.selectedSnap = chosenSnap
        }
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = snapArray[indexPath.row].userEmail
        cell.userNameLabel.text = snapArray[indexPath.row].userName
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray.last!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "feedToSnap", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
