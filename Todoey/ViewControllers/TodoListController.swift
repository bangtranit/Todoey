//
//  ViewController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/13.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit

class TodoListController: UITableViewController {

    var arrayTodo = ["Find watch", "Buy eyys", "Clean the chicken"]
    let cellIdentifier : String = "ToDoItem"
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
        cell.textLabel?.text = arrayTodo[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
       }else{ tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark}
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

