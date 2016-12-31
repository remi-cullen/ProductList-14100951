//
//  ViewController.swift
//  ProductList:14100951
//
//  Created by Remi Cullen on 29/12/2016.
//  Copyright © 2016 Remi Cullen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    var products = [NSManagedObject]() //Core data object array that will load and save items
    
    @IBAction func addItem(_ sender: UIButton)
    {
        
    }
    
    
    func saveName(name: String) {  //coreData function to save a name with the value name which is already set in the coreData entity
        //call on the app delegate to accept data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext) //defining entity
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)//item object
        
        item.setValue(name, forKey: "name") //assigning the value to the key
        do {
            try managedContext.save()
            products.append(item)
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Shopping List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

