//
//  CategoryViewController.swift
//  Yaddoey
//
//  Created by Khalid SH on 26/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        loadCategorys()
        
    }
    /*-----------------------------------------------------------------------------------------------------------------------------------------
     ----------------------------------------------------------------------()---------------------------------------------------------------------
     ---------------------------------------------------------------------------*/
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!!"
        print(cell.textLabel!.text!)
        return cell
    }
    /*-----------------------------------------------------------------------------------------------------------------------------------------
     ----------------------------------------------------------------------()---------------------------------------------------------------------
     -----------------------------------------------------------------------*/
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCategoryList", sender: self)
    }
    /*-----------------------------------------------------------------------------------------------------------------------------------------
     ----------------------------------------------------------------------()---------------------------------------------------------------------
     -----------------------------------------------------------------------*/
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.category = categories?[indexPath.row]
        }
    }
    /*-----------------------------------------------------------------------------------------------------------------------------------------
     ----------------------------------------------------------------------()---------------------------------------------------------------------
     -----------------------------------------------------------------------*/
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
    /*-----------------------------------------------------------------------------------------------------------------------------------------
     ----------------------------------------------------------------------()---------------------------------------------------------------------
     ---------------------------------------------------------------------------*/
    // MARK: - Realm Data Presisting Methods, Saving, loading, deleting
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
                //action.fulfill(with: .delete)
            } catch {
                print("Error Trying To Delete a Category named: \(categoryToDelete.name)\n Error:\(error)")
            }
            //self.tableView.reloadData()
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
        
        if let indexOfSavedCategory = categories?.index(of: category){
            print(indexOfSavedCategory)
            print(tableView.numberOfSections)
            //tableView.reloadData()
            //tableView.reloadRows(at: [IndexPath(row: indexOfSavedCategory, section: 0)], with: .automatic)
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        }
        
    }
    
    func loadCategorys() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
/*-----------------------------------------------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------()---------------------------------------------------------------------
 ---------------------------------------------------------------------------*/
// MARK: - Swipeable Cell Delegate Methods
//extension CategoryViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            if let categoryToDelete = self.categories?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(categoryToDelete)
//                    }
//                    //action.fulfill(with: .delete)
//                } catch {
//                    print("Error Trying To Delete a Category named: \(categoryToDelete.name)\n Error:\(error)")
//                }
//                //self.tableView.reloadData()
//            }
//        }
//
//        //deleteAction.image = UIImage(named: "delete")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructiveAfterFill
//        return options
//    }
//}
