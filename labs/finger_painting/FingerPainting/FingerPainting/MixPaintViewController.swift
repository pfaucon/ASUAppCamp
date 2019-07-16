//
//  MixPaintViewController.swift
//  FingerPainting
//
//  Created by Ryan Dougherty on 6/28/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import UIKit

@objc protocol MixPaintViewControllerDelegate {
    @objc optional func mixPaint(aMixer: AnyObject, aColor: UIColor)
    @objc optional func mixPaintBrushThickness(aMixer: AnyObject, brushThickness:Double)
    @objc optional func mixPaintOpacity(aMixer: AnyObject, opacity: Double)
}

class MixPaintViewController: UIViewController {
    
    var delegate: MixPaintViewControllerDelegate?

    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var brushSizeLabel: UILabel!
    @IBOutlet weak var paintColorButton: UIButton!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        let newColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        self.paintColorButton.backgroundColor = newColor
    }

    @IBAction func updateColor() {
        let red = CGFloat(self.redSlider.value)
        let green = CGFloat(self.greenSlider.value)
        let blue = CGFloat(self.blueSlider.value)
        
        self.brushSizeLabel.text = String(brushSlider.value)
        self.opacityLabel.text = String(opacitySlider.value)
        
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        self.paintColorButton.backgroundColor = newColor
        
        self.paintColorButton.setNeedsDisplay()
        
        if self.delegate?.mixPaint != nil {
            self.delegate?.mixPaint!(aMixer: self, aColor: self.paintColorButton.backgroundColor!)
        }
        
        if self.delegate?.mixPaintBrushThickness != nil {
            self.delegate?.mixPaintBrushThickness!(aMixer: self, brushThickness: Double(brushSlider.value))
        }
        
        if self.delegate?.mixPaintOpacity != nil {
            self.delegate?.mixPaintOpacity!(aMixer: self, opacity: Double(opacitySlider.value))
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
