//
//  ViewController.swift
//  SecretHandshake
//
//  Created by Ali Muhammad Rafiq on 6/25/16.
//  Copyright (c) 2016 Ali Muhammad Rafiq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var matchView: UIImageView!
    
    @IBOutlet weak var handshakeMatcher: HandshakeMatches!
    
    var secretHandshake = Array<String>()
    var currentStep = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let handshakeMatcher = HandshakeMatches(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 60))
        self.handshakeMatcher = handshakeMatcher
        self.view.addSubview(self.handshakeMatcher)
        self.handshakeMatcher?.numberOfGestures = self.secretHandshake.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secretHandshake = ["LEFT", "LEFT", "UP"]
    }
    
    func drawImageForGestureRecognizer(imageName: String, atPoint: CGPoint) {
        print(imageName)
        self.imageView.image = UIImage(named: imageName)
        self.imageView.center = atPoint
        self.imageView.alpha = 1.0
    }
    
    @IBAction func playAgain(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "segueToVictory", sender: self)
    }
    
    @IBAction func handleSwipes(sender: UISwipeGestureRecognizer) {
        
        var image = "Incorrect.png"
        
        let startLocation = sender.location(in: self.view)
        
        var endLocation = startLocation
        
        if sender.direction == .up {
            image = "Up.png"
            endLocation.y -= 220.0
            print(secretHandshake)
            if secretHandshake[currentStep] == "UP" {
                currentStep += 1
            } else {
                currentStep = 0
            }
        }
        else if sender.direction == .down {
            image = "Down.png"
            endLocation.y += 220.0
            if secretHandshake[currentStep] == "DOWN" {
                currentStep += 1
            } else {
                currentStep = 0
            }
        }
        else if sender.direction == .left {
            image = "Left.png"
            endLocation.x -= 220.0
            if secretHandshake[currentStep] == "LEFT" {
                currentStep += 1
            } else {
                currentStep = 0
            }
        }
        else if sender.direction == .right {
            image = "Right.png"
            endLocation.x += 220.0
            if secretHandshake[currentStep] == "RIGHT" {
                currentStep += 1
            } else {
                currentStep = 0
            }
        }
        else {
            print("Unrecognized swipe!")
        }
        
        self.handshakeMatcher.correctGuesses = currentStep
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
        self.drawImageForGestureRecognizer(imageName: image, atPoint: startLocation)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0.0
            self.imageView.center = endLocation
        });
        
        self.updateMatchStatus()
    }

    func updateMatchStatus() {
        if currentStep == 0 {
            // No successful matches
            self.matchView.image = UIImage(named: "Incorrect.png")
        }
        else if currentStep < secretHandshake.count {
            // At least 1 gesture matched, but there are more...
            self.matchView.image = UIImage(named: "Matching.png")
        }
        else {
            // Matched all the gestures!
            self.matchView.image = UIImage(named: "Correct.png")
            currentStep = 0
        }
    }
}
