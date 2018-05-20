//
//  TodoListController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/13.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListController: SwipeTableViewController {
    
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
        initUI()
    }
    
    func initUI(){
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
        navigationController?.navigationBar.barTintColor = UIColor(hexString: (parentCatalog?.color)!)
    }
    
    //MARK: TableView datasource - delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTodo?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {   
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = arrayTodo?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
            if let color = UIColor(hexString: (parentCatalog?.color)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((arrayTodo?.count)!)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }else{
            cell.textLabel?.text = "There aren't any item"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = arrayTodo?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving \(error)")
            }
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    //MARK: Handel remove item
    override func handleDelete(indexPath: IndexPath) {
        do{
            try realm.write {
                self.realm.delete((self.arrayTodo?[indexPath.row])!)
            }
        }catch{
            print("Error when try to delete item \(error)")
        }
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
                let newItem = Item()
                newItem.title = textField.text!
                newItem.done = false
                newItem.dateCreated = DateHelper.sharedDateHelper.getCurrentDate()
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
        arrayTodo = parentCatalog?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func loadAllTask(){
        loadItem()
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
            self.loadAllTask()
            self.searchBar.resignFirstResponder()
        }
    }

    func searchWithKeyWord(keyword: String){
        arrayTodo = arrayTodo?.filter( "title CONTAINS[cd] %@", keyword).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}

