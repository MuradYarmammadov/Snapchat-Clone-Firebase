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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var imageUrlArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setPageControl()
        setCollectionView()
    }
    
    private func setUI(){
        if let snap = selectedSnap {
            timeLabel.text = "Time Left: \(snap.timeDifference)"

            for imageUrl in snap.imageUrlArray {
                imageUrlArray.append(imageUrl)
            }
        }
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = imageUrlArray.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension SnapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! SnapCollectionViewCell
        let imageUrl = imageUrlArray[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: imageUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = indexPath.item
        }
    }
}
