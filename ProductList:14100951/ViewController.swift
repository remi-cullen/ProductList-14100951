//
//  ViewController.swift
//  ProductList:14100951
//
//  Created by Remi Cullen on 29/12/2016.
//  Copyright © 2016 Remi Cullen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var secondTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /*AUTOCOMPLETE SECTION*/
   var autoCompleteWords = ["Apple", "Banana","Bread","Cake","Cookies","Crackers","Cucumber","Dates","Eggs","Milk","Cheese","Ham","Butter","Oranges","Tuna","Tomatoes","Chicken","Sauce","Noodles","Leeks","Salt","Sugar","Flour","Strawberrys","Lettuce","Spices","Bacon","Sweets"]
    var autoComplete = [String]()
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let subString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        
        
        searchThroughAutoCompleteWithSubstring(subString:subString)
        
        return true
    }
    
    func searchThroughAutoCompleteWithSubstring(subString: String)
    {
        autoComplete.removeAll(keepingCapacity: false)
        
        for key in autoCompleteWords
        {
            let myString: NSString! = key as NSString
            let stringRange: NSRange! = myString.range(of: subString)
            
            if (stringRange.location == 0)
            {
                autoComplete.append(key)
            }
        }
        secondTableView.reloadData()
    }
    /*************************************/
    
    var products = [NSManagedObject]() //Core data object array that will load and save items
    
    @IBAction func addItem(_ sender: UIButton)
    {
        if textField.text != ""
        {
            self.tableView.dataSource = self
            let itemName = textField.text!
            self.saveName(name: itemName)
           
            self.tableView.reloadData()
            textField.text = ""
            textField.resignFirstResponder()
  
        
        }
    
        
        
}

    
    func saveName(name: String) {  //coreData function to save a name with the value name which is already set in the coreData entity
        //call on the app delegate to accept data
        
        
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
/*************Table View Methods**************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.secondTableView {
            return autoComplete.count
        }
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.secondTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath)
            let index = indexPath.row as Int
            cell.textLabel?.text = autoComplete[index]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = products[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "name") as? String
        
        return cell
    }
    //checkmarks
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.secondTableView
        {
            let selectedCell: UITableViewCell = secondTableView.cellForRow(at: indexPath)!
            textField.text = selectedCell.textLabel!.text!
            
            
        }
        else
        {
            let thisRow = tableView.cellForRow(at: indexPath)!
        
            if thisRow.accessoryType == UITableViewCellAccessoryType.none
            {
                thisRow.accessoryType = UITableViewCellAccessoryType.checkmark
                thisRow.tintColor = UIColor.blue
                let itemName = thisRow.textLabel?.text
                let alert = UIAlertController(title: "New Product", message: "\(itemName!) added to your shopping cart", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler:
                    {(action: UIAlertAction) -> Void in
            
                        print("\(itemName! ) added to your shopping cart")
                })
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
            else
            {
                thisRow.accessoryType = UITableViewCellAccessoryType.none
            }
        }
    }
    //delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        print("Deleted")
        let deletedRow = tableView.cellForRow(at: indexPath)!
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            //Delete from coreData
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                try managedContext.delete(products[indexPath.row])
                products.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                deletedRow.accessoryType = UITableViewCellAccessoryType.none
                try managedContext.save()
            } catch let error as NSError {
                print(error)
            }
            tableView.reloadData()
        }
    }
    
    
/***************End****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Shopping List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.secondTableView.delegate = self
        self.textField.delegate = self
        secondTableView.register(UITableViewCell.self, forCellReuseIdentifier: "aCell")
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            products = results as! [NSManagedObject]
        }
        catch let error as NSError {
            print(error)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

