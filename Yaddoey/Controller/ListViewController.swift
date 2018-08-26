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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                 todoArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error while louding ")
            }
        }
    }
    
    
    // MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let item = todoArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = todoArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    
    // MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoArray[indexPath.row].done = !todoArray[indexPath.row].done
        self.updateData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK - Add new item to todoArray
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add New Yaddoy Todo", message: "", preferredStyle: .alert)
        func addTextField(){
            addAlert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Write a New Todo"
            }
        }
        addTextField()
        while((addAlert.textFields?.last?.text?.isEmpty)! && (addAlert.textFields?.last?.isEditing)!){
            addTextField()
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let itemTitle = addAlert.textFields![0].text
            let newItem = (itemTitle == "") ? (nil) : (Item(addAlert.textFields![0].text!))
            if newItem == nil {
                return
            } else {
                self.todoArray.append(newItem!)
                self.updateData()
                self.tableView.reloadData()
            }
        }
        addAlert.addAction(action)
        present(addAlert, animated: true)
       
    }
    
    
    // MARK - Reuseble Functions
    
    func updateData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(todoArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error while Encoding and Writing the Items List!!\nError:\(error)")
        }
        tableView.reloadData()
    }
}

