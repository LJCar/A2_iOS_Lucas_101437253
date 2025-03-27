//
//  ViewController.swift
//  A2_iOS_Lucas_101437253
//
//  Created by Tech on 2025-03-26.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let context = appDelegate.persistentContainer.viewContext
        
        let products = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let count = try context.count(for: products)
            if count == 0 {
                let newProducts = [
                    (1, "iPhone", "Apple smartphone", "499.99", "Apple Inc."),
                    (2, "iPad", "Apple tablet PC", "599.99", "Apple Inc."),
                    (3, "AirPods", "Apple wireless Bluetooth earbuds", "399.99", "Apple Inc."),
                    (4, "MacBook", "Apple Laptop", "1399.00", "Apple Inc."),
                    (5, "EarPods", "Apple headphones", "25.00", "Apple Inc."),
                    (6, "Apple Watch", "Apple Smart Watch", "580.00", "Apple Inc."),
                    (7, "iMac", "Apple Desktop Computer", "1699.00", "Apple Inc."),
                    (8, "HomePod", "Apple Bluetooth Smart Speaker", "129.99", "Apple Inc." ),
                    (9, "AirTag", "Apple Bluetooth signal detector", "36.22", "Apple Inc."),
                    (10, "Gift Card", "Apple Gift Card", "82.96", "Apple Inc.")
                ]
                
                for (id, name, desc, price, provider) in newProducts {
                    let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
                    product.setValue(id, forKey: "id")
                    product.setValue(name, forKey: "name")
                    product.setValue(desc, forKey: "desc")
                    product.setValue(NSDecimalNumber(string: price), forKey: "price")
                    product.setValue(provider, forKey: "provider")
                }
                
                try context.save()
                print("Products Inserted.")
            } else {
                print("Ready for new Products")
            }
        } catch {
            print("Error loading Products: \(error)")
        }
    }
}

