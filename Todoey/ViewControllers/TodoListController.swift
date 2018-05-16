//
//  TodoListController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/13.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit

class TodoListController: UITableViewController {
    
    var arrayTodo = [ItemObj]()
    let cellIdentifier : String = "ToDoItem"
    let keyUserDefault : String = "ARRAY_TODO"
    let userDefault = UserDefaults.standard
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadDataFromUserDefault()
        readDataFromFile(url: dataFilePath!)
        print(dataFilePath!)
    }
    
    //MARK: Save and load to UserDefault
    func loadDataFromUserDefault(){
        if let items = userDefault.array(forKey: keyUserDefault) as? [ItemObj] {
            arrayTodo = items
        }
    }

    func saveToUserDefault(){
        userDefault.set(arrayTodo, forKey: keyUserDefault)
        userDefault.synchronize()
    }
    
    //MARK: Write data to file
    func writeDataToFile(item: ItemObj){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.arrayTodo)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error \(error)")
        }
    }

    func readDataFromFile(url : URL){
        if let data = try? Data(contentsOf: url) {
            do{
                let decoder = PropertyListDecoder()
                arrayTodo = try decoder.decode([ItemObj].self, from: data)
            }catch{
                print("Error\(error)")
            }
        }
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
                let item = ItemObj(title_str: textField.text!, done_status: false)
                self.arrayTodo.append(item)
                self.tableView .reloadData()
                let encoder = PropertyListEncoder()
                do{
                    let data = try encoder.encode(self.arrayTodo)
                    try data.write(to: self.dataFilePath!)
                }catch{
                    print("Error \(error)")
                }
                //                self.saveToUserDefault()
                self.writeDataToFile(item: item)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

