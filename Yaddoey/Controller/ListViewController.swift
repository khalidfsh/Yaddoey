//
//  ViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 23/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    var todoArray = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        todoArray.append(Item("do this"))
        if let items = defaults.array(forKey: "YaddoyItemList") as? [Item]{
            todoArray = items
        }
    }
    
    //MARK - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let item = todoArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoArray[indexPath.row].done = !todoArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new item to todoArray
    @IBAction func addButtonPressed(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add New Yaddoy Todo", message: "", preferredStyle: .alert)
        addAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write a New Todo"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let itemTitle = addAlert.textFields![0].text
            let newItem = (itemTitle == "") ? (nil) : (Item(addAlert.textFields![0].text!))
            if newItem == nil {
                return
            }
            self.todoArray.append(newItem!)
            print("mooooooo")
           // self.defaults.set(self.todoArray, forKey: "YaddoyItemList")
            self.tableView.reloadData()

        }
        addAlert.addAction(action)
        present(addAlert, animated: true)
       
    }
}

