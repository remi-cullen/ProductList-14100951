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
    
    @IBAction func addItem(_ sender: UIButton) {
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

