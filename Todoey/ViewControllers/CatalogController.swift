//
//  CatalogController.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/19.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CatalogController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var arrayCalalog : Results<Catalog>?
    var cellIdentifer : String = "CatologItem"
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
        return arrayCalalog?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath)
        cell.textLabel?.text = arrayCalalog?[indexPath.row].name ?? "No catalog added yet"
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
        destinationVC.parentCatalog = arrayCalalog?[rowChoosed]
    }
    
    //MARK: Database
    func loadAllCatalog(){
        loadCatalog()
    }
    
    func saveCatalog(catalog : Catalog){
        do{
            try realm.write {
                realm.add(catalog)
            }
        }catch{
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCatalog(){
        arrayCalalog = realm.objects(Catalog.self)
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
                let newCatalog = Catalog()
                newCatalog.name = textField.text!
                self.saveCatalog(catalog: newCatalog)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

//SearchBar
//extension CatalogController : UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("search bar \(searchBar.text!)")
//        if searchBar.text?.isEmpty ?? true{
//            loadAllCatalog()
//            searchBar.resignFirstResponder()
//        }else{
//            searchByKeyWord(keyword: searchBar.text!)
//        }
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchByKeyWord(keyword: searchBar.text!)
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("Cancel")
//    }
//
//    func searchByKeyWord(keyword:String){
//        let fetRequest : NSFetchRequest<Catalog> = Catalog.fetchRequest()
//        fetRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", keyword)
//        fetRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        loadCatalog(request: fetRequest)
//    }
//}
