//
//  TableViewController.swift
//  2 Project
//
//  Created by mac on 5/30/16.
//  Copyright © 2016 Alder. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let meme = memes[indexPath.row]
        cell.textLabel?.text = "\(meme.topTextField!) \(meme.bottomTextField!)"
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addNew))
        
    }
    
    func addNew() {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "addVC") as! MemeEditorViewController
        self.present(addVC, animated: true, completion: nil)
    
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            myTableView.reloadData()

            
        }
    }

    
}
