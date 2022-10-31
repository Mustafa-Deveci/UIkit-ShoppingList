//  DetailsVC.swift
//  ShoppingList
//  Created by mustafa deveci on 29.10.2022.

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var SelectedProductName = ""
    var SelectedProductUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SelectedProductName != ""  {
            
            saveButton.isHidden = true
            
            if let uuidString = SelectedProductUUID?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                
                do{
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            
                            if let name = result.value(forKey: "name") as? String {
                                nameTextField.text = name
                            }
                            
                            if let price = result.value(forKey: "price") as? Int {
                                priceTextField.text = (String)(price)
                            }
                            
                            if let size = result.value(forKey: "size") as? String {
                                sizeTextField.text = size
                            }
                            
                            if let imageData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: imageData)
                                imageView.image = image
                            }
                        }
                    }
                }catch {
                        print("error")
                    }
                }
    
        } else {
            saveButton.isHidden = false
            saveButton.isEnabled = false
            nameTextField.text = ""
            priceTextField.text = ""
            sizeTextField.text = ""
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
    }
    
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        saveButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        shopping.setValue(nameTextField.text!, forKey: "name")
        shopping.setValue(sizeTextField.text!, forKey: "size")
        
        if let price = Int(priceTextField.text!) {
            shopping.setValue(price, forKey: "price")
        }
        
        shopping.setValue(UUID(), forKey: "id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.7)
        shopping.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("saved")
        }catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
