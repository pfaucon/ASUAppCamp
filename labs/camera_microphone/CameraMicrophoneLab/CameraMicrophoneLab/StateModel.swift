//
//  StateModel.swift
//  CameraMicrophoneLab
//
//  Created by Xiaoxiao on 6/25/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit
import AVFoundation

class StateModel: NSObject, AVAudioPlayerDelegate {
    
    //add these to store the image we are using, and the sound recording/playback tool
    var image: UIImage!
    var recordingURL: NSURL!
    var player: AVAudioPlayer!
    
    //this is a special variable that is used to retrieve the one instance of our StateModel
    static let sharedInstance = StateModel()

    // We can still have a regular init method, that will get called the first time the Singleton is used.
    override private init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        }
        catch {
            print("Failed to initialize session.")
        }
    }
    
    // This is a setter to set the URL for the player
    func setRecURL(recordingURL: NSURL) {
        self.recordingURL = recordingURL
        do {
            self.player = try AVAudioPlayer(contentsOf: recordingURL as URL)
        }
        catch {
            print("Failed to find the recording!")
        }
        self.player.delegate = self
    }

}
