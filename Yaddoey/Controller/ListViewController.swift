//
//  ViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 23/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ListViewController: SwipeTableViewController {
    
    let realm = try? Realm()
    var category: Category? {
        didSet{
            loadItems()
        }
    }
    var todoItems: Results<Item>?
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
        
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    //MARK: - UIView methods
    
    override func viewWillAppear(_ animated: Bool) {
        if let color = category?.cellBackgroundColor {
            title = category!.name
            updateNavBar(hexColor: color)

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(hexColor: "1D9BF6")
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Update navigation bar view function
    func updateNavBar (hexColor: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError()}
        guard let color = UIColor.init(hexString: hexColor) else {fatalError()}
        
        navBar.barTintColor = color
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        searchBar.barTintColor = color
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Table view data source
        /*--------------------------------------------------------*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: (category?.cellBackgroundColor)!)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(todoItems!.count)) ) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Todo Items Added Yet!!"
            print(cell.textLabel!.text!)
        }
        return cell
    }
    
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Table view delegate methods
        /*--------------------------------------------------------*/
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Add a new Yaddoy item functionallty
        /*--------------------------------------------------------*/
    @IBAction func addButtonPressed(_ sender: Any) {
        let addAlert = UIAlertController(title: "عمل جديد", message: "", preferredStyle: .alert)
        addAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "اكتب العمل"
        }
        let action = UIAlertAction(title: "أضف", style: .default) { (action) in
            if let itemTitle = addAlert.textFields?[0].text {
                do {
                    try self.realm?.write {
                        let newItem = Item()
                        newItem.title = itemTitle
                        newItem.dateCreated = Date()
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
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Data presisting methods, Saving, loading, deleting
        /*--------------------------------------------------------*/
    override func deleteModel(at indexPath: IndexPath) {
        if let itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try realm!.write {
                    realm!.delete(itemToDelete)
                }
            } catch {
                print("Error Trying To Delete a Category named: \(itemToDelete.title)\n Error:\(error)")
            }
        }
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemToUpdate = self.todoItems?[indexPath.row] {
            do {
                try realm!.write {
                    itemToUpdate.done = !itemToUpdate.done
                }
            } catch {
                print("Error Trying To Delete a Category named: \(itemToUpdate.title)\n Error:\(error)")
            }
            self.tableView.reloadData()
        }
    }
    
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
        todoItems = category?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}

/*------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------*/
// MARK: - Search Bar Methods
    /*--------------------------------------------------------*/
extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

