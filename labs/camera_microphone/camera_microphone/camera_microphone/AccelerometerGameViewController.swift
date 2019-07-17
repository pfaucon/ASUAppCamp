//
//  AccelerometerGameViewController.swift
//  CameraMicrophoneLab
//
//  Created by Xiaoxiao on 6/26/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation


class AccelerometerGameViewController: UIViewController {

    // Properties from the interface.
    @IBOutlet weak var xlabel: UILabel!
    @IBOutlet weak var ylabel: UILabel!
    @IBOutlet weak var zlabel: UILabel!
    @IBOutlet var imageButton: UIButton!
    
    // How often should we update our position and velocity?
    var accelerometerUpdate : Timer!
    var motionManager: CMMotionManager!
    
    // This is the default audio player
    var audioPlayer: AVAudioPlayer!
    
    // These can track our velocity
    var xVelocity: CGFloat!
    var yVelocity: CGFloat!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //load up our image
        let model = StateModel.sharedInstance
        if model.image != nil {
            self.imageButton.setImage(model.image, for: .normal)
        }
        
        //create an accelerometer manager
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.1
        self.motionManager.startAccelerometerUpdates()
        
        //reset velocity to nil so our image starts out at a normal speed
        self.xVelocity = 0
        self.yVelocity = 0
        
        //attach the timer
        self.accelerometerUpdate = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        //set up the default audio player
        let audioFilePath = Bundle.main.path(forResource: "Boing", ofType: "wav")
        if audioFilePath != nil {
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
                audioPlayer.prepareToPlay()
            }
            catch {
                print("can't create audio player")
            }
        }
    }

    @objc func update() {
        
        // get the current accelerometer data
        if self.motionManager.accelerometerData != nil {
            let accelerometerData = self.motionManager.accelerometerData!
            
            //print the "x" acceleration into the xlabel, do the same for y and z
            self.xlabel.text = String(format: "%.4f", accelerometerData.acceleration.x)
            self.ylabel.text = String(format: "%.4f", accelerometerData.acceleration.y)
            self.zlabel.text = String(format: "%.4f", accelerometerData.acceleration.z)
            
            // update the velocity:
            self.xVelocity = self.xVelocity + CGFloat(accelerometerData.acceleration.x) * 0.9
            self.yVelocity = self.yVelocity + CGFloat(accelerometerData.acceleration.y) * -0.9
        }
 
        //update the position
        let center = self.imageButton.center
        let destx = center.x + self.xVelocity * 1
        let desty = center.y + self.yVelocity * 1
        
        // set the updated position
        let dest = CGPoint(x: destx, y: desty)
        self.imageButton.center = dest
        
        // check for collisions and correct them if necessary
        self.enforceBoundary()
    }
    
    func enforceBoundary() {
        
        var bump = false
        
        // find out where our image is trying to go
        let center = self.imageButton.center
        var destx = center.x
        var desty = center.y
        
        //how big is our image?
        let xRadius = self.imageButton.frame.size.width / 2
        let yRadius = self.imageButton.frame.size.height / 2
        
        //are we trying to leave the "left" side?
        if destx - xRadius < 0 {
            
            // make sure that the center of the image would be one radius distance
            // from the edge
            destx = self.imageButton.frame.size.width / 2
            
            //invert the velocity to simulate a bounce
            self.xVelocity = -self.xVelocity
            bump = true
        }
        
        if destx + xRadius > self.view.frame.size.width {
            
            destx = self.view.frame.size.width - xRadius
            self.xVelocity = -self.xVelocity
            bump = true
        }
        
        if desty - yRadius < 0 {
            
            desty = self.imageButton.frame.size.height / 2
            self.yVelocity = -self.yVelocity
            bump = true
        }
        
        if desty + yRadius > self.view.frame.size.height {
            
            desty = self.view.frame.size.height - yRadius
            self.yVelocity = -self.yVelocity
            bump = true
        }
        
        //reconstruct the image location and move the image to that point
        let dest = CGPoint(x: destx, y: desty)
        self.imageButton.center = dest
        
        if(bump) {
            
            // when the sound is stored
            if let player = StateModel.sharedInstance.player {
                player.play()
            }
            // else play the dafault sound
            else {
                if audioPlayer != nil {
                    audioPlayer.play()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.accelerometerUpdate.invalidate()
    }

}
