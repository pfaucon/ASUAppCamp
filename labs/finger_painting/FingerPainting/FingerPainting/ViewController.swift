//
//  ViewController.swift
//  FingerPainting
//
//  Created by Ryan Dougherty on 6/28/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MixPaintViewControllerDelegate {

    @IBOutlet var paintView: PaintView!

    func mixPaint(aMixer: AnyObject, aColor: UIColor) {
        self.paintView.brushColor = aColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMix" {
            let dest = segue.destination as! MixPaintViewController
            dest.delegate = self
        }
    }
    
    func mixPaintBrushThickness(aMixer: AnyObject, brushThickness: Double) {
        self.paintView.brushThickness = brushThickness
    }
    
    func mixPaintOpacity(aMixer: AnyObject, opacity: Double) {
        self.paintView.opacity = opacity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

