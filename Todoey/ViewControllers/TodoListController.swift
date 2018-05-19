//
//  TodoListController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/13.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import CoreData
class TodoListController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var arrayTodo = [Item]()
    let cellIdentifier : String = "ToDoItem"
    let userDefault = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllTask()
    }
    
    //MARK: TableView datasource - delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTodo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {   
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = arrayTodo[indexPath.row].title
        cell.accessoryType = arrayTodo[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrayTodo[indexPath.row].setValue(!arrayTodo[indexPath.row].done, forKey: "done")
        saveItem()
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
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.arrayTodo.append(newItem)
                self.saveItem()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Database
    func saveItem(){
        do{
            try self.context.save()
        }catch{
            print("Has error when saving \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem(request: NSFetchRequest<Item>){
        do{
          arrayTodo = try context.fetch(request)
        }catch{
            print("Error when loading item \(error)")
        }
    }
    
    func loadAllTask(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        loadItem(request: request)
        tableView.reloadData()
    }
}

//MARK: Search bar
extension TodoListController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWithKeyWord(keyword: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWithKeyWord(keyword: searchBar.text!)
        if searchBar.text?.isEmpty == true {
            loadAllTask()
        }
    }
    
    func searchWithKeyWord(keyword: String){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", keyword)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(request: request)
        tableView.reloadData()
    }
}

