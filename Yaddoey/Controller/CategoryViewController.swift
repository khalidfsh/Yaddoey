//
//  CategoryViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 26/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorys()
        
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        if let category = categories?[indexPath.row] {
            print("whaaaat \(category)")
            cell.textLabel?.text = category.name
        } else {
            cell.textLabel?.text = "No Categories Added Yet!!"
            print(cell.textLabel!.text!)

        }
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCategoryList", sender: self)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.category = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Add a new Yaddoy Category functionallty
    @IBAction func addButtonPressed(_ sender: Any) {
        let createCategoryAlert = UIAlertController(title: "Create a new Yaddoy Category", message: "", preferredStyle: .alert)
        createCategoryAlert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "write your category name"
        }
        createCategoryAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (addActionButton) in
            if let categoryName = createCategoryAlert.textFields?[0].text{
                let newCategory = Category()
                newCategory.name = categoryName
                self.save(newCategory)
            } else {
                return
            }
        }))
        
        present(createCategoryAlert, animated: true)
    }
    
    
    // MARK: - Data presisting methods, Saving and loading
    
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
