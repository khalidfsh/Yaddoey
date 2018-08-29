//
//  CategoryViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 26/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        loadCategorys()
        
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            guard let color = UIColor.init(hexString: category.cellBackgroundColor) else {fatalError()}
            cell.textLabel?.text = category.name
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoList", sender: self)
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.category = categories?[indexPath.row]
        }
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Add a new Yaddoy Category functionallty
    @IBAction func addButtonPressed(_ sender: Any) {
        let createCategoryAlert = UIAlertController(title: "أضف مجلد اعمال جديد", message: "", preferredStyle: .alert)
        createCategoryAlert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "اكتب اسم المجلد"
        }
        createCategoryAlert.addAction(UIAlertAction(title: "أضف", style: .default, handler: { (addActionButton) in
            if let categoryName = createCategoryAlert.textFields?[0].text{
                let newCategory = Category()
                newCategory.name = categoryName
                newCategory.cellBackgroundColor = UIColor.randomFlat.hexValue()
                self.save(newCategory)
            } else {
                return
            }
        }))
        
        present(createCategoryAlert, animated: true)
    }
    /*------------------------------------------------------------------------------------------------
     ------------------------------------------------------------------------------------------------*/
    // MARK: - Realm Data Presisting Methods, Saving, loading, deleting
    
    override func deleteModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete.items)
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error Trying To Delete a Category named: \(categoryToDelete.name)\n Error:\(error)")
            }
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToUpdate = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    for item in categoryToUpdate.items {
                        item.done = true
                    }
                }
            } catch {
                print("Error Trying To Delete a Category named: \(categoryToUpdate.name)\n Error:\(error)")
            }
        }
    }
    
    func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error While Saving Category!!\nError:\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategorys() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
