//
//  CollectionViewController.swift
//  GillespieMemeFinal
//
//  Created by Travis Gillespie on 8/11/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var memes: [MemeObject]!

    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memesObjectCollectionCell", forIndexPath: indexPath) as! MemesObjectCollectionCell
        let meme = memes[indexPath.item]
        cell.memesImage.image = meme.memedImage
        cell.memesLabelTop.text = meme.topText
        cell.memesLabelBottom.text = meme.bottomText
        cell.flowLayout.minimumInteritemSpacing = space
        cell.flowLayout.minimumLineSpacing = space
        cell.flowLayout.itemSize = CGSizeMake(dimension, dimension)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")!
        let detailVC = object as! DetailViewController
        let indexOfObject = indexPath.row
        detailVC.selectedMemeArrayIndex = indexOfObject
        detailVC.selectedMeme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func addMemeButton(sender: AnyObject) {
        performSegueWithIdentifier("segueCollectionToViewController", sender: self)
    }
}