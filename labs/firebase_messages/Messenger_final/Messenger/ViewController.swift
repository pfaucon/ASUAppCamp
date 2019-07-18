//
//  ViewController.swift
//  Messenger
//
//  Created by mfraiz on 7/10/18.
//  Copyright © 2018 mfraiz. All rights reserved.
//

import Firebase
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //ViewController Class Variables
    var messageList:[Message] = [];
    
    @IBOutlet weak var messageTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up Firebase Observer
        
        //Firebase Loading
        let listReference = Database.database().reference().child("Messages")
        //Call the observe function to set up the observer
        listReference.observe(.value, with: { snapshot in
            //Handler Function Body
            //Create an empty list
            var newList:[Message] = []
            // For each item in the list
            for item in snapshot.children {
                let data = item as! DataSnapshot
                let message = data.value as! [String:AnyObject]
                
                //Create a new message
                let aMessage = Message(jsonObj: message)
                
                newList.append(aMessage)
            }
            
            self.messageList = newList
            self.messageTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
        return messageList.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "messageCell", for: indexPath)
        cell.textLabel?.text = messageList[indexPath.row].message
        cell.textLabel?.textColor = messageList[indexPath.row].textColor
        
        //set up background color
        let colorName = messageList[indexPath.row].bgColor!
        
        cell.textLabel?.layer.backgroundColor = stringToColor(colorName: colorName).cgColor
        
        
        
        
        
        return cell;
    }
    
    func stringToColor(colorName:String) -> UIColor
    {
        var colorForBG:UIColor? = UIColor.white
        
        switch colorName
        {
        case "Gray":
            colorForBG = UIColor.gray
            
        case "Black":
            colorForBG = UIColor.black
            
        case "Blue":
            colorForBG = UIColor.blue
            
        case "Red":
            colorForBG = UIColor.red
            
        case "White":
            colorForBG = UIColor.white
            
        default: break
            
        }
        
        return colorForBG!
    }
    
    //Tableview Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //Get the key of the item to be removed.
        let nameOfItemToBeDeleted = messageList[indexPath.row].message
        
        //Get the location in the JSON tree of the item to be deleted.
        let deleteReference = Database.database().reference().child("Messages").child(nameOfItemToBeDeleted!)
        
        //Delete the item by changing the value to nil
        deleteReference.setValue(nil)
        
        //Note you can also delete with
        // deleteReference.removeValue()
        // Both functions are valid.
    }
    
    
    @IBAction func goToAddPopUp(_ sender: Any) {
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addPopUpVC") as! AddPopUpController
        
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
    }
    
    //Prepare Segue Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! DetailViewViewController
        let selectedIndex: IndexPath = self.messageTable.indexPath(for: sender as! UITableViewCell)!
        destination.message = messageList[selectedIndex.row].message
        destination.textColor = messageList[selectedIndex.row].textColor
        destination.bgColor = stringToColor(colorName: messageList[selectedIndex.row].bgColor!)
        
        
    }
    
    
}

