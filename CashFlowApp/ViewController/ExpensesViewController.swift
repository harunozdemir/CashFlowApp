//
//  ExpensesViewController.swift
//  CashFlowApp
//
//  Created by Harun on 30.09.2018.
//  Copyright © 2018 harun. All rights reserved.
//

import UIKit

class ExpensesViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBAction func tappedActionSheet(_ sender: Any) {
        showActionSheet()
    }
    
    
   
    @IBAction func tappedAddExpense(_ sender: Any) {
          showAddExpenseVC()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.searchBar.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: "Record", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let expense = UIAlertAction(title: "Expense", style: .default) { action in
            self.showAddExpenseVC()
            
        }
        
        let mileage = UIAlertAction(title: "Mileage", style: .default) { action in
            let alert = UIAlertController(title: "Error", message: "You will have to configure your mileage preferences before you will be able to add a mileage expense.Please use our web application to configure your mileage preferences", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
       
        }
        
        actionSheet.addAction(expense)
        actionSheet.addAction(mileage)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showAddExpenseVC(){
          performSegue(withIdentifier: "addExpenseSegue", sender: self)
    }
   

}



