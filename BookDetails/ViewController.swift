//
//  ViewController.swift
//  BookDetails
//
//  Created by gomathi saminathan on 1/8/20.
//  Copyright © 2020 Rajendran Eshwaran. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var tableview : UITableView!
    
   
    var bookname : String = ""
    var bookprice :String = ""
    var bookmodel = [BookModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        readDataFromCoreData()
    }

    
    @IBAction func addItem(sender : Any)
    {
        
        let alert = UIAlertController(title: " Book Entry Record", message: "Add Book Details", preferredStyle: UIAlertController.Style.alert)
        
        // Add button
        let addAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let usernameTxt = alert.textFields![0]
            let passwordTxt = alert.textFields![1]
            //Asign textfileds text to our global varibles"
            self.bookname = usernameTxt.text!
            self.bookprice = passwordTxt.text!

            print("bookname \(String(describing: self.bookname))\n bookprice\(String(describing: self.bookprice))")
                        
            self.bookmodel.append(BookModel(bookName: self.bookname, bookPrice: self.bookprice))
             self.saveDataToCoreData()
            print(self.bookmodel.description)
            self.tableview.reloadData()
            
           

        })

        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })

        //1 textField for BookName
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter BookName"
            //If required mention keyboard type, delegates, text sixe and font etc...
            //EX:
            textField.keyboardType = .default
        }

        //2nd textField for BookPrice
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter BookPrice"
            textField.isSecureTextEntry = false
        
        }

        // Add actions
        alert.addAction(addAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    
    func saveDataToCoreData()
    {
    //s1
        let context = DBManager.shareManager.persistentContainer.viewContext
    //s2
        guard let entityName = NSEntityDescription.entity(forEntityName: "BookTable", in: context) else {return}
    //s3
        let managedObj = NSManagedObject(entity: entityName, insertInto: context)
        managedObj.setValue(self.bookname, forKey: "bookname")
        managedObj.setValue(self.bookprice, forKey: "bookprice")
     //s4
        do{
            try context.save()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func readDataFromCoreData()
    {
     //s1
        let context = DBManager.shareManager.persistentContainer.viewContext
     //s2
        let fetchReq = NSFetchRequest <NSFetchRequestResult>(entityName: "BookTable")
     //s3
        do{
            let result = try context.fetch(fetchReq)
            for data in result as![NSManagedObject]
            {
                let bname = data.value(forKey: "bookname")
                let bprice = data.value(forKey: "bookprice")
                print("Read \(bname ?? "xxx") \(bprice ?? 0)")
                bookmodel.append(BookModel(bookName: bname as! String, bookPrice: bprice as! String))
            }
        }
        catch{
            print("Failed to get Data")
        }
        
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmodel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let result = bookmodel[indexPath.row]
        cell.textLabel?.text = result.bookName
        cell.textLabel?.text = result.bookPrice

        return cell
    }

    
}



