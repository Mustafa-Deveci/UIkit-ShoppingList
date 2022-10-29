//  DetailsVC.swift
//  ShoppingList
//  Created by mustafa deveci on 29.10.2022.

import UIKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
}
