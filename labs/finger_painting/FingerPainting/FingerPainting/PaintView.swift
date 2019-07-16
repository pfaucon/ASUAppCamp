//
//  PaintView.swift
//  FingerPainting
//
//  Created by Ryan Dougherty on 6/28/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import UIKit

class PaintView: UIView {

    var brushColor: UIColor?
    var tempDrawImage: UIImageView? = UIImageView()
    var lastTouch: CGPoint?
    
    var brushThickness: Double = 0.0
    var opacity: Double = 0.0

    // resets painter to black colored brush
    @IBAction func resetButton(sender: AnyObject) {
        self.configure()
        self.setNeedsDisplay()
    }
    // clears the canvas
    @IBAction func eraseButton(sender: AnyObject) {
        self.tempDrawImage = UIImageView()
        self.setNeedsDisplay()
    }
    // paints white to simulate an eraser
    @IBAction func clearButton(sender: AnyObject) {
        let eraseColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        self.brushColor = eraseColor
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    // this is a helper method to allow us to set whatever default settings we would like to use
    // if you'd like you can even override the .image property to that we have an image at startup
    func configure() {
        self.brushColor = UIColor.black
        self.brushThickness = 15
        self.opacity = 1
    }
    
    // when a user puts a finger on the screen this method is called automatically
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.lastTouch = touch?.location(in: self)
    }
    
    // when a user who has previously put a finger on the screen moves that finger
    // this method is called, we will use it to draw the new line segment
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //where did the user's touch(finger) move to?
        let touch = touches.first
        guard let currentPoint = touch?.location(in: self) else {
            return
        }
        
        guard let lastTouch = self.lastTouch else {
            return;
        }
        
        //open a graphics context with the old image
        UIGraphicsBeginImageContext(self.frame.size)
        self.tempDrawImage!.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        //draw a line from the last touch to the current touch
        guard let context = UIGraphicsGetCurrentContext() else {
            return;
        }
        context.move(to: CGPoint(x: lastTouch.x, y: (lastTouch.y)))
        context.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
        context.setLineWidth(CGFloat(self.brushThickness))
        context.setAlpha(CGFloat(self.opacity))
        
        //configure our drawing options
        context.setLineCap(.round)
        context.setStrokeColor(self.brushColor?.cgColor ?? UIColor.black.cgColor)
        
        //draw the actual line
        context.strokePath()
        
        //store the updated image so that we can draw it more easily
        self.tempDrawImage!.image = UIGraphicsGetImageFromCurrentImageContext()
        self.tempDrawImage!.alpha = 0.5
        UIGraphicsEndImageContext()
        
        //update the last touch, and refresh the image as seen on the screen
        self.lastTouch = currentPoint
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        UIGraphicsGetCurrentContext()
        self.tempDrawImage!.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
    }
}
