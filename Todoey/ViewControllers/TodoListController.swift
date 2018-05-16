//
//  TodoListController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/13.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit

class TodoListController: UITableViewController {
    
    var arrayTodo = [Item]()
    let cellIdentifier : String = "ToDoItem"
    let keyUserDefault : String = "ARRAY_TODO"
    let userDefault = UserDefaults.standard
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        arrayTodo[indexPath.row].done = !arrayTodo[indexPath.row].done
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
                self.saveItem(item: newItem)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(item : Item){
        do{
            try self.context.save()
        }catch{
            print("Has error when saving \(error)")
        }
    }
    
}

