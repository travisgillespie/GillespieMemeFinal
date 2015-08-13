//
//  TableViewController.swift
//  GillespieMemeFinal
//
//  Created by Travis Gillespie on 8/11/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableViewDynamic: UITableView!
    
    var memes: [MemeObject]!
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes

        self.tableView.reloadData()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memesObjectTableCell", forIndexPath: indexPath) as! MemesObjectTableCell
        let specificMeme = self.memes[indexPath.row]
        cell.memesLabel?.text = "\(specificMeme.topText) \(specificMeme.bottomText)"
        cell.memesImage?.image = specificMeme.memedImage
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")!
        let detailVC = object as! DetailViewController
        let indexOfObject = indexPath.row
        detailVC.selectedMemeArrayIndex = indexOfObject
        detailVC.selectedMeme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func addMemeButton(sender: AnyObject) {
        performSegueWithIdentifier("segueTableToViewController", sender: self)
    }
}