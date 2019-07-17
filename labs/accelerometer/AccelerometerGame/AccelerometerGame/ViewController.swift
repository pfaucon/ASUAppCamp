//
//  ViewController.swift
//  AccelerometerGame
//
//  Created by Alexander Nou on 6/25/16.
//  Copyright © 2016 ASU Summer Camp 2016. All rights reserved.
//

import UIKit
import CoreMotion //add this 


class ViewController: UIViewController {
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    
    //add the properties below
    var accelerometerUpdate = Timer();
    var motionManager = CMMotionManager();
    
    /*
     OR it can be explicitly defined
     var acceleromterUpdate2 : NSTimer!
     var motionmanager : CMMotionManager!
     */
    
    
    var xVelocity : CGFloat = 0;
    var yVelocity : CGFloat = 0;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.1 //0.1 second interval between updates
        self.motionManager.startAccelerometerUpdates()
        
        self.accelerometerUpdate = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update(timer:)), userInfo: nil, repeats: true)
        
        print("Finished appearance")
    }
    
    @objc func update(timer: Timer) {
        
        //get the current accelerometer data
        if let accelerometerData = self.motionManager.accelerometerData {
            
            //print the accelerations on the x, y, and z axis in the respective labels
            self.xLabel.text = String(format: "%0.4f", accelerometerData.acceleration.x)
            self.yLabel.text = String(format: "%0.4f", accelerometerData.acceleration.y)
            self.zLabel.text = String(format: "%0.4f", accelerometerData.acceleration.z)
            
            //update the velocity
            self.xVelocity = self.xVelocity + CGFloat(accelerometerData.acceleration.x * 0.1)
            self.yVelocity = self.yVelocity - CGFloat(accelerometerData.acceleration.y * 0.1)
            
            //update the position
            let center = self.imageButton.center
            let destx = center.x + self.xVelocity * 0.1
            let desty = center.y + self.yVelocity * 0.1
            
            //set the updated position
            let dest = CGPoint( x: destx, y: desty)
            self.imageButton.center = dest
            
            // check for collisions, update if necessary
            self.enforceBoundary();
        }
        if !(self.view.frame.contains(self.imageButton.frame)) {
            print("Bump")
        }
    }
    
    func enforceBoundary() {
        //find out where our image is trying to go
        let center = self.imageButton.center;
        var destx = center.x;
        var desty = center.y;
        
        //how big is our image?
        let xRadius = self.imageButton.frame.size.width/2;
        let yRadius = self.imageButton.frame.size.height/2;
        
        //are we trying to leave the "left" side?
        if (destx - xRadius < 0) {
            
            //make sure that the center of the image would be one radius distance
            //from the edge
            destx = self.imageButton.frame.size.width/2;
            
            //invert the velocity to simulate a bounce
            self.xVelocity = -self.xVelocity;
        }
        
        if (destx + xRadius > self.view.frame.size.width) {
            destx = self.view.frame.size.width - xRadius
            self.xVelocity = -self.xVelocity
        }
        
        if (desty - yRadius < 0) {
            desty = self.imageButton.frame.size.height/2;
            self.yVelocity = -self.yVelocity
        }
        
        if (desty + yRadius > self.view.frame.size.height) {
            desty = self.view.frame.size.height - yRadius
            self.yVelocity = -self.yVelocity
        }
        
        //reconstruct the image location and move the image to that point
        let dest = CGPoint( x: destx, y: desty)
        self.imageButton.center = dest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doSomthing() {
        
    }
    
}

