//
//  ViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 23/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit

class toDoListViewController: UITableViewController {
    
    var todoArray = ["do that.", "doing this.", "did that."]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        cell.textLabel?.text = todoArray[indexPath.row]
        return cell
    }
    
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new item to todoArray
    @IBAction func addButtonPressed(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add New Yaddoy Todo", message: "", preferredStyle: .alert)
        addAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write a New Todo"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            (addAlert.textFields![0].text == "") ? (print("empty")) : (self.todoArray.append(addAlert.textFields![0].text!))
            self.tableView.reloadData()
        }
        addAlert.addAction(action)
        present(addAlert, animated: true)
       
    }
    
}

