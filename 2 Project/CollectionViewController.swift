//
//  CollectionViewController.swift
//  2 Project
//
//  Created by mac on 5/31/16.
//  Copyright © 2016 Alder. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myCollectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count

    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.cellImageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addNew))
        settingFlowLayout(self.view.frame.size)

        
        
    }
    
    func settingFlowLayout(_ size: CGSize) {
        if (flowLayout != nil) {
        let space: CGFloat = 2.0
        let dimension:CGFloat = size.width >= size.height ? (size.width - (5 * space)) / 6.0 :  (size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        settingFlowLayout(size)

    }


    
    func addNew() {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "addVC") as! MemeEditorViewController
        self.present(addVC, animated: true, completion: nil)
        
        
        
    }
    
    
}

