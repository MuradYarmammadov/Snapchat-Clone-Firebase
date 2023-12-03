//
//  SnapViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit

class SnapViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var selectedSnap : Snap?
    var timeLeft: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let time = timeLeft {
            timeLabel.text = "Time Left: \(time)"
        }
    }

}
