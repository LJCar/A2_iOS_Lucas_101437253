//
//  AddProductViewController.swift
//  A2_iOS_Lucas_101437253
//
//  Created by Tech on 2025-03-27.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController {

    @IBOutlet weak var productNameField: UITextField!
    @IBOutlet weak var productDescField: UITextField!
    @IBOutlet weak var productPriceField: UITextField!
    @IBOutlet weak var productProviderField: UITextField!
    
    @IBAction func addProductTap(_ sender: UIButton) {
        saveProduct()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func saveProduct() {
        guard
            let name = productNameField.text, !name.isEmpty,
            let desc = productDescField.text, !desc.isEmpty,
            let priceString = productPriceField.text, !priceString.isEmpty,
            let provider = productProviderField.text, !provider.isEmpty
        else { return
        }
        
        let price = NSDecimalNumber(string: priceString)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["id"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        var nextProductId = 1
        if let result = try? context.fetch(fetchRequest),
           let first = result.first as? [String: Any],
           let maxId = first["id"] as? Int {
            nextProductId = maxId + 1
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: context)!
        let product = NSManagedObject(entity: entity, insertInto: context)
        
        product.setValue(nextProductId, forKey: "id")
        product.setValue(name, forKey: "name")
        product.setValue(desc, forKey: "desc")
        product.setValue(price, forKey: "price")
        product.setValue(provider, forKey: "provider")
        
        do {
            try context.save()
            productNameField.text = ""
            productDescField.text = ""
            productPriceField.text = ""
            productProviderField.text = ""
            
            let alert = UIAlertController(title: "Success", message: "Product Saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default){ _ in self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        } catch {
            print("Failed to Save: \(error)")
        }
    }
}
