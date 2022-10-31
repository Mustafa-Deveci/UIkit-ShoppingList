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
    var selectedName = ""
    var selectedUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "addedData"), object: nil)
    }
    
    @objc func getData()  {
        
        arrId.removeAll()
        arrName.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        arrName.append(name)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        arrId.append(id)
                    }
                }
                tableView.reloadData()
                
            }
            
        } catch {
            print("an error")
            
            
        }
    }
    @objc func addButtonClicked(){
        selectedName = ""
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.SelectedProductName = selectedName
            destinationVC.SelectedProductUUID = selectedUUID
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = arrName[indexPath.row]
        selectedUUID = arrId[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
            let uuidString = arrId[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == arrId[indexPath.row]{
                                context.delete(result)
                                arrName.remove(at: indexPath.row)
                                arrId.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                do {
                                    try context.save()
                                } catch {
                                    print("error")
                                    
                                }
                                break
                            }
                        }
                    }
                }
                tableView.reloadData()
                
            } catch {
                print("an error")
            }
        }
    }
}
        
        
