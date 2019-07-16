//
//  HandshakeMatches.swift
//  SecretHandshake
//
//  Created by Ryan Dougherty on 6/27/16.
//  Copyright © 2016 Ali Muhammad Rafiq. All rights reserved.
//

import UIKit

class HandshakeMatches: UIView {

    var incorrectImage = UIImage()
    var matchingImage = UIImage()
    var correctImage = UIImage()
    
    var imageViews = Array<UIImageView>()
    
    var numberOfGestures: Int = 0 {
        didSet {
            for imageView in self.imageViews {
                imageView.removeFromSuperview()
            }
            self.imageViews.removeAll()
            
            // Add new image views
            for _ in 1...numberOfGestures {
                let imageView = UIImageView()
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                self.imageViews.append(imageView)
                self.addSubview(imageView)
            }
            
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    var correctGuesses: Int = 0 {
        didSet {
            self.refresh()
            self.setNeedsDisplay()
        }
    }
    
    var midMargin = 0
    var leftMargin = 0
    var minImageSize = CGSize()
    
    func baseInit() {
        self.incorrectImage = UIImage(named: "Incorrect.png")!
        self.correctImage = UIImage(named: "Correct.png")!
        self.matchingImage = UIImage(named: "Matching.png")!
        self.midMargin = 5
        self.leftMargin = 0
        self.minImageSize = CGSize(width: 5, height: 5)
        self.numberOfGestures = 5
        print("Handshake matches initialized!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.baseInit()
    }

    func refresh() {
        for i in 0...self.imageViews.count-1 {
            let imageView = self.imageViews[i]
            if self.correctGuesses >= i+1 {
                imageView.image = self.correctImage
            }
            else {
                imageView.image = self.matchingImage
            }
        }
    }
    
    func notateIncorrectMatch() {
        self.correctGuesses = 0
        self.setNeedsDisplay()
    }
    
    func notateCorrectMatch() {
        self.correctGuesses += 1
        self.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let desiredImageWidth = (self.frame.size.width - CGFloat(self.leftMargin*2) - CGFloat(self.midMargin*self.imageViews.count)) / CGFloat(self.imageViews.count)
        let imageWidth = max(self.minImageSize.width, desiredImageWidth)
        let imageHeight = max(self.minImageSize.height, self.frame.size.height)
        for i in 0...self.imageViews.count-1 {
            let imageView = self.imageViews[i]
            let imageFrame = CGRect(x: CGFloat(self.leftMargin) + CGFloat(i)*(CGFloat(self.midMargin)+imageWidth), y: 0, width: imageWidth, height: imageHeight)
            imageView.frame = imageFrame
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.refresh()
        let desiredImageWidth = (self.frame.size.width - CGFloat(self.leftMargin*2) - CGFloat(self.midMargin*self.imageViews.count)) / CGFloat(self.imageViews.count)
        let imageWidth = max(self.minImageSize.width, desiredImageWidth)
        let imageHeight = max(self.minImageSize.height, self.frame.size.height)
        for i in 0...self.imageViews.count-1 {
            let imageView = self.imageViews[i]
            let imageFrame = CGRect(x: CGFloat(self.leftMargin) + CGFloat(i)*(CGFloat(self.midMargin)+imageWidth), y: 0, width: imageWidth, height: imageHeight)
            imageView.frame = imageFrame
        }
    }
}
