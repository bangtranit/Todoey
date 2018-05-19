//
//  CatalogController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/19.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import CoreData

class CatalogController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrayCalalog = [Catalog]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let cellIdentifer : String = "CatologItem"
    var rowChoosed : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    //MARK: Init
    func initUI(){
        
    }
    
    func initData(){
        loadAllCatalog()
    }
    
    //MARK: Table DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCalalog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath)
        cell.textLabel?.text = arrayCalalog[indexPath.row].name
        return cell
    }
    //MARK: Table Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rowChoosed = Int(indexPath.row)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListController
        //        if let indexPath = tableView.indexPathForSelectedRow{
        destinationVC.parentCatalog = arrayCalalog[rowChoosed]
        //        }
    }
    
    //MARK: Database
    func loadAllCatalog(){
        let request : NSFetchRequest<Catalog> = Catalog.fetchRequest()
        loadCatalog(request: request)
    }
    
    func saveCatalog(){
        do{
            try context.save()
        }catch{
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCatalog(request : NSFetchRequest<Catalog> = Catalog.fetchRequest()){
        do{
            arrayCalalog = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        tableView.reloadData()
    }
    
    
    @IBAction func onClickAddCatalog(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Catalog", message: "Add new catalog", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input your catalog"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            print(textField.text!)
            
            if textField.text?.isEmpty ?? true{
            }else{
                let newCatalog = Catalog(context: self.context)
                newCatalog.name = textField.text!
                self.arrayCalalog.append(newCatalog)
                self.saveCatalog()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

//SearchBar
extension CatalogController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar \(searchBar.text!)")
        if searchBar.text?.isEmpty ?? true{
            loadAllCatalog()
            searchBar.resignFirstResponder()
        }else{
            searchByKeyWord(keyword: searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchByKeyWord(keyword: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
    }
    
    func searchByKeyWord(keyword:String){
        let fetRequest : NSFetchRequest<Catalog> = Catalog.fetchRequest()
        fetRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", keyword)
        fetRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadCatalog(request: fetRequest)
    }
}
