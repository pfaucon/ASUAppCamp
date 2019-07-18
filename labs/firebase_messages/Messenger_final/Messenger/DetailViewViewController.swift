//
//  DetailViewViewController.swift
//  Messenger
//
//  Created by mfraiz on 7/13/18.
//  Copyright © 2018 mfraiz. All rights reserved.
//

import UIKit
import Firebase

class DetailViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Class Variables
    var message:String?
    var bgColor:UIColor?
    var textColor:UIColor?
    var responseArray:[String] = []
    
    //Class Outlets
    @IBOutlet weak var responseTable: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var respondField: UITextField!
    
    //Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "responseCell", for: indexPath)
        cell.textLabel?.text = responseArray[indexPath.row]
        
        
        return cell
        
        
    }
    
    
    @IBAction func respond(_ sender: Any) {
        
        let response = self.respondField.text!
        
        if(stringIsValid(inputString: response))
        {
            //Get ref
            let responseRef = Database.database().reference().child("Messages").child(message!).child("response").child(response)
            //Change Value
            responseRef.setValue(response)
        }
        else {
            
            let alert = UIAlertController(title: "Invalid Response!", message: "Response cannot be empty or contain any of the following characters: . # $ [ or ] " , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
            print("Not Valid String!")
        }
       
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        backgroundView.backgroundColor = bgColor
        messageLabel.textColor = textColor

        //Set up response observer
        
        let listReference = Database.database().reference().child("Messages").child(message!).child("response")
        //Call the observe function to set up the observer
        listReference.observe(.value, with: { snapshot in
            //Handler Function Body
            //Create an empty list
            var newList:[String] = []
            // For each item in the list
            for item in snapshot.children {
                let data = item as! DataSnapshot
                let aResponse = data.value as! String
                print(aResponse)
                
                //Create a new message
                
                
                newList.append(aResponse)
                
                
            }
            self.responseArray = newList
            self.responseTable.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }
    
    //Make sure no invalid characters are used for the names like . # $ [ or ]
    func stringIsValid(inputString:String) -> Bool
    {
        //Check if empty
        if(inputString == "")
        {
            return false
        }
            //Check if it has an invalid character
        else if (inputString.contains(".") || inputString.contains("#") || inputString.contains("$") || inputString.contains("[") || inputString.contains("]"))
        {
            return false
        }
            //Else it will be fine
        else {
            return true
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
