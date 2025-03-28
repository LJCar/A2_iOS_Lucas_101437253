//
//  ViewController.swift
//  A2_iOS_Lucas_101437253
//
//  Created by Tech on 2025-03-26.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var productList: [NSManagedObject] = []
    
    var filteredProducts: [NSManagedObject] = []
    var isSearching = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        searchBar.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.isHidden = true
        
        
        
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
            }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            if let results = try? context.fetch(fetchRequest) as? [NSManagedObject] {
                productList = results
                tableView.reloadData()
            }
        } catch {
            print("Error loading Products: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredProducts.count : productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        
        let product = isSearching ? filteredProducts[indexPath.row] : productList[indexPath.row]
        let name = product.value(forKey: "name") as? String ?? "No Product Name"
        let desc = product.value(forKey: "desc") as? String ?? "No Description"
        
        cell.textLabel?.text = "Product Name: \(name)"
        cell.textLabel?.textColor = UIColor.systemBlue
        cell.detailTextLabel?.text = "Product Description: \(desc)"
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            isSearching = false
        } else {
            isSearching = true
            filteredProducts = productList.filter {
                let name = ($0.value(forKey: "name") as? String ?? "").lowercased()
                let desc = ($0.value(forKey: "desc") as? String ?? "").lowercased()
                return name.contains(searchText.lowercased()) || desc.contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.isHidden = true
        isSearching = false
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = appDelegate.persistentContainer.viewContext
        let products = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        products.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            if let results = try context.fetch(products) as? [NSManagedObject] {
                productList = results
                tableView.reloadData()
            }
        } catch {
            print("Error loading Products: \(error)")
        }
    }

}

