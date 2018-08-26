//
//  ViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 23/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController {
    
    let realm = try? Realm()
    var category: Category? {
        didSet{
            navigationItem.title = category?.name
            loadItems()
        }
    }
    var todoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            print("whaaaat \(item)")
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Todo Items Added Yet!!"
            print(cell.textLabel!.text!)
        }
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm?.write {
                    item.done = !item.done
                }
            } catch {
                print("Error While Trying To Update an Item!!\n\(error)")
            }
        }
        tableView.reloadData()
//        context.delete(todoArray[indexPath.row])
//        todoArray.remove(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add a new Yaddoy item functionallty
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add New Yaddoy Todo", message: "", preferredStyle: .alert)
        addAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write a New Todo"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let itemTitle = addAlert.textFields![0].text {
                do {
                    try self.realm?.write {
                        let newItem = Item()
                        newItem.title = itemTitle
                        self.category?.items.append(newItem)
                    }
                } catch {
                    print("Error While Trying to Save New Todo Item to Realm!!\n\(error)")
                }
            } else {
                return
            }
            self.tableView.reloadData()
        }
        addAlert.addAction(action)

        present(addAlert, animated: true)
    }
    
    
    // MARK: - Data presisting methods, Saving and loading
    
    func save(_ item: Item) {
        do{
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            print("Error while writing a todo item to Realem!\n\(error)")
        }
        
    }
    
    func loadItems() {
        todoItems = category?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}


// MARK: - Search Bar Methods

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS %@ ", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

