//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/20.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func visibleRect(for tableView: UITableView) -> CGRect? {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    
    //MARK: TableView Datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.handleDelete(indexPath: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "TrashIcon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func handleDelete(indexPath: IndexPath){
        print("Delete at index ",indexPath.row)
    }
}
