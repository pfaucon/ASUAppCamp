//
//  Message.swift
//  Messenger
//
//  Created by mfraiz on 7/10/18.
//  Copyright © 2018 mfraiz. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Message
{
    
    //Class Variables
    var textColor:UIColor?
    var bgColor:String?
    var message:String?
    var responses:[String] = []
    
    var redColor:CGFloat?
    var greenColor:CGFloat?
    var blueColor:CGFloat?
    //Default Initializer
    init()
    {
        
    }
    
    init(jsonObj: [String:AnyObject]){
        message = jsonObj["message"] as? String
        
        redColor = jsonObj["textRed"] as? CGFloat
        greenColor = jsonObj["textGreen"] as? CGFloat
        blueColor = jsonObj["textBlue"] as? CGFloat
        
        textColor = UIColor(red: redColor ?? 1.0,
                            green: greenColor  ?? 1.0,
                            blue: blueColor ?? 1.0,
                            alpha: 1)
        
        bgColor = jsonObj["bgColor"] as? String
    }
    
    //Initializer that creates a new message
    init(aMessage: String, aBgColor: String, aTextColor: UIColor, someResponses: [String])
    {
        self.message = aMessage
        self.bgColor = aBgColor
        self.textColor = aTextColor
        self.responses = someResponses
    }
    
    /**Helper Method that produces a set of key value pairs with string names pointing to data values. This is something we can pass to the firebase to add entries to our database
     **/
    func toJSONObject() -> Any
    {
        
        //Convert UIColor to RGB
        let coreImageColor = CIColor(color: textColor!)
        
        let redValue = Double(coreImageColor.red)
        let greenValue = Double(coreImageColor.green)
        let blueValue = Double(coreImageColor.blue)
        
        return [
            "message": self.message!,
            "textRed": redValue,
            "textGreen": greenValue,
            "textBlue": blueValue,
            "bgColor": self.bgColor!
            ]
        
        //"responses": ["Hi", "Okay", "Test"]
    }
    
    //func responseToArray() -> Any
    //{
        
    //}
    
    
    
    
    
}
