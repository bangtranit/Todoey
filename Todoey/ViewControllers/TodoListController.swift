//
//  TodoListController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/13.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
class TodoListController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var arrayTodo : Results<Item>?
    let realm = try! Realm()
    
    let cellIdentifier : String = "ToDoItem"
    var parentCatalog : Catalog? {
        didSet{
            loadAllTask()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: TableView datasource - delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTodo?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {   
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let item = arrayTodo?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "There aren't any item"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        arrayTodo![indexPath.row].setValue(!arrayTodo![indexPath.row].done, forKey: "done")
        //        saveItem(item: Item)
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new action
    @IBAction func onClickAddNewAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Action", message: "Add new action", preferredStyle: .alert)
        alert.addTextField { (aTextField) in
            aTextField.placeholder = "Please input action's name"
            textField = aTextField
        }
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            print(textField.text!)
            
            if textField.text?.isEmpty ?? true{
            }else{
//                do{
//                    try self.realm.write {
//                        let newItem = Item()
//                        newItem.title = textField.text!
//                        newItem.done = false
////                        self.parentCatalog?.items.append(newItem)
//                    }
//                }catch{
//                    print("Error when add new item \(error)")
//                }
//                self.tableView.reloadData()
                let newItem = Item()
                newItem.title = textField.text!
                newItem.done = false

                self.saveItem(item: newItem)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Database
    func saveItem(item: Item){
        do{
            try realm.write {
                realm.add(item)
                self.parentCatalog?.items.append(item)
            }
        }catch{
            print("Error when add new item \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem(){
        arrayTodo = parentCatalog?.items.sorted(byKeyPath: "title", ascending: true)
        
    }
    
    func loadAllTask(){
        tableView.reloadData()
    }
}

//MARK: Search bar
//extension TodoListController : UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchWithKeyWord(keyword: searchBar.text!)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchWithKeyWord(keyword: searchBar.text!)
//        if searchBar.text?.isEmpty == true {
//            self.loadAllTask()
//            self.searchBar.resignFirstResponder()
//        }
//    }
//
//    func searchWithKeyWord(keyword: String){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", keyword)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItem(request: request, predicate: predicate)
//        tableView.reloadData()
//    }
//}

