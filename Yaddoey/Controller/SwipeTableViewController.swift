//
//  SwipeTableViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 27/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var deleteSwipeOrient: SwipeActionsOrientation = .right
    var doneSwipeOrient: SwipeActionsOrientation = .left
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSwipeOrientation()
        
    }
    
    func updateSwipeOrientation() {
        if let languageCode = NSLocale.current.languageCode {
            if languageCode == "ar"{
                deleteSwipeOrient = .left
                doneSwipeOrient = .right
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == deleteSwipeOrient {
            let deleteAction = SwipeAction(style: .destructive, title: "حذف") { action, indexPath in
                self.deleteModel(at: indexPath)
            }
            
            //deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
        } else if orientation == doneSwipeOrient {
            let doneAction = SwipeAction(style: .default , title: "تم") { action, indexPath in
                self.updateModel(at: indexPath)
            }
            
            //deleteAction.image = UIImage(named: "done")
            
            return [doneAction]
        } else { return nil}
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == doneSwipeOrient ? .selection : .destructive
        return options
    }
    
    func deleteModel (at indexPath: IndexPath){
        
    }
    
    func updateModel (at indexPath: IndexPath){
        
    }
    
}
