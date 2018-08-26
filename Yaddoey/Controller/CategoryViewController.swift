//
//  CategoryViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 26/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorys()
        
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
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
            destination.category = categories[indexPath.row]
        }
    }
    
    
    // MARK: - Add a new Yaddoy Category functionallty
    @IBAction func addButtonPressed(_ sender: Any) {
        let createCategoryAlert = UIAlertController(title: "Create a new Yaddoy Category", message: "", preferredStyle: .alert)
        createCategoryAlert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "write your category name"
        }
        createCategoryAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (addActionButton) in
            let categoryName = createCategoryAlert.textFields![0].text
            
            if (categoryName?.isEmpty)! {
                return
            } else {
                let newCategory = Category(context: self.context)
                newCategory.name = categoryName
                self.categories.append(newCategory)
                self.saveCategorys()
            }
            
        }))
        
        present(createCategoryAlert, animated: true)
    }
    
    
    // MARK: - Data presisting methods, Saving and loading
    
    func saveCategorys() {
        do {
            try context.save()
        } catch {
            print("Error while Writing the Items List!!\nError:\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategorys(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categories = try context.fetch(request)
        } catch {
            print("Error while Requesting Data from Database\nError: \(error)")
        }
        
        tableView.reloadData()
    }
}
