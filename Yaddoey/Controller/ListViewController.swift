//
//  ViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 23/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var category: Category? {
        didSet{
            navigationItem.title = category?.name
            loadItems()
        }
    }
    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
//        context.delete(todoArray[indexPath.row])
//        todoArray.remove(at: indexPath.row)
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add a new Yaddoy item functionallty
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add New Yaddoy Todo", message: "", preferredStyle: .alert)
        addAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write a New Todo"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let itemTitle = addAlert.textFields![0].text
            
            if itemTitle == "" {
                return
            } else {
                let newItem = Item(context: self.context)
                newItem.done = false
                newItem.title = itemTitle
                newItem.category = self.category
                self.items.append(newItem)
                self.saveItems()
            }
        }
        addAlert.addAction(action)
        
        present(addAlert, animated: true)
    }
    
    
    // MARK: - Data presisting methods, Saving and loading
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error while Writing the Items List!!\nError:\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        let catagoryPredicate = NSPredicate(format: "category.name MATCHES %@", self.category!.name!)
        
        if (request.predicate) != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request.predicate!, catagoryPredicate])
        } else {
            request.predicate = catagoryPredicate
        }
        
        do{
            items = try context.fetch(request)
        } catch {
            print("Error while Requesting Data from Database\nError: \(error)")
        }
        
        tableView.reloadData()
    }
}


// MARK: - Search Bar Methods

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title CONTAINS %@ ", searchBar.text!)
        
        request.predicate = searchPredicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
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

