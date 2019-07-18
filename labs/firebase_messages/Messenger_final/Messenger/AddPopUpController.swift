//
//  AddPopUpController.swift
//  Messenger
//
//  Created by mfraiz on 7/10/18.
//  Copyright © 2018 mfraiz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ColorPickerSlider

class AddPopUpController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    //Class Functions
    var colorArray = ["Gray","White", "Black", "Red", "Blue"]
    var bgColorName = "Gray"
 
    
    @IBOutlet weak var PopUpView: UIView!
    
    @IBOutlet weak var textColor: UILabel!
    
    @IBOutlet weak var messageField: UITextField!
    
    //viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Pop up Set up
        
        //Set the background to a somewhat transparent black
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        //Play an animation to make the pop up look better
        
        //First set alpha to 0 to hide the view
        self.view.alpha = 0.0
        //Use a scale transformation to make the view larger
        self.view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        //Now create an animation to return the view back to default values over a period of time
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            
        })
        
        //////////////////////////////////////////////////////////
        //Set up ColorPicker for TextColor
        // Sample view to display selected color.
        let selectedColorDisplayView = UIView(frame: CGRect(x: self.PopUpView.center.x - 80,
                                                            y: self.PopUpView.center.x + 100,
                                                            width: 25,
                                                            height: 25))
        selectedColorDisplayView.backgroundColor = UIColor.red
        self.textColor.textColor = UIColor.red
        self.messageField.textColor = UIColor.red
        
        
        self.view.addSubview(selectedColorDisplayView)
        
       
        
        
        // ColorPickerView initialisation
        let colorPickerframe = CGRect(x: 35,
                                      y: 60,
                                      width: self.PopUpView.frame.size.width - 40,
                                      height: 140)
        let colorPicker = ColorPickerView(frame: colorPickerframe)
        colorPicker.didChangeColor = { color in
            selectedColorDisplayView.backgroundColor = color
            self.textColor.textColor = color
            self.messageField.textColor = color
        }
        PopUpView.addSubview(colorPicker)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let colorName = colorArray[row]
        var colorForBG:UIColor?
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
            
            default:
            colorForBG = UIColor.white
        }
        
        self.messageField.backgroundColor = colorForBG
        self.bgColorName = colorName
        return colorName
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
    
    
    @IBAction func SendMessagePressed(_ sender: Any) {
        
        if(stringIsValid(inputString: self.messageField.text!))
        {
            //Create Message Object
            let newMessage = Message()
            newMessage.message = self.messageField.text!
            newMessage.textColor = self.messageField.textColor!
            newMessage.bgColor = self.bgColorName
            
            
            //Write Object to Firebase
            
            let rootRef = Database.database().reference()
            let messageListRef = rootRef.child("Messages")
            let thisMessageRef = messageListRef.child(newMessage.message!)
            
            thisMessageRef.setValue(newMessage.toJSONObject())
            closeView()
        }
        else {
            
            let alert = UIAlertController(title: "Invalid Message!", message: "Message cannot be empty or contain any of the following characters: . # $ [ or ] " , preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
            print("Not Valid String!")
        }
        
        
        
    }
    
    //Helper function that closes the view after doing a little animation
    func closeView()
    {
        //Performs two animations, when finished it will remove the view letting us return to the superview which is our tableView controller
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0;
            self.view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }) { (finished: Bool) in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        }
    }
    
    
    
    
}
