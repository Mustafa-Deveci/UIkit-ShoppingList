//
//  ViewController.swift
//  ShoppingList
//  Created by mustafa deveci on 29.10.2022.

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrName = [String]()
    var arrId = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        getData()
    }
    
    func getData()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    arrName.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    arrId.append(id)
                }
            }
            tableView.reloadData()
        } catch {
            print("an error")
            
            
        }
    }
    @objc func addButtonClicked(){
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = arrName[indexPath.row]
        return cell
    }
}

