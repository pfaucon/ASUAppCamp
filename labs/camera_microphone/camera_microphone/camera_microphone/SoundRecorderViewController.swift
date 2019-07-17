//
//  SoundRecorderViewController.swift
//  CameraMicrophoneLab
//
//  Created by Xiaoxiao on 6/25/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit
import AVFoundation

class SoundRecorderViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var recordPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Disable Stop/Play buttons when application launches.
        self.stopButton.isEnabled = false
        self.playButton.isEnabled = false

        // Set up audio session.
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        }
        catch {
            print("Failed to initialize recording session.")
        }
        
        // Define the recorder setting.
        let recordSetting = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2 as NSNumber,
            ] as [String : Any]
        
        // Set the audio file.
        let outputFileURL = getAudioURL()
        
        // Initialize and prepare the recorder.
        do {
            recorder = try AVAudioRecorder(url: outputFileURL as URL, settings: recordSetting)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
        }
        catch {
            print("Failed to initialize the recorder.")
        }
        
    }

    // Where are we going to save the recording?
    func getAudioURL() -> NSURL {
        
        let pathComponents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [NSString]
        let audioFileName = pathComponents[0].appendingPathComponent("MyAudioMemo.m4a")
        return NSURL(fileURLWithPath: audioFileName)
    }

    @IBAction func recordPauseTapped(sender: UIButton) {
    
        // Stop the audio player before recording.
        if self.player != nil{
            if self.player.isPlaying {
                self.player.stop()
            }
        }
        
        if !self.recorder.isRecording {
            
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true)
            }
            catch {
                print("Fail to start recording session.")
            }
            
            // Start recording.
            self.recorder.record()
            self.recordPauseButton.setTitle("Pause", for: .normal)
        }
        else {
            
            // Pause recording.
            self.recorder.pause()
            self.recordPauseButton.setTitle("Record", for: .normal)
        }
        
        self.playButton.isEnabled = true
        self.stopButton.isEnabled = true
    }
    
    @IBAction func stopTapped(sender: UIButton) {
        
        self.recorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        }
        catch {
            print("Failed to complete the recording.")
        }
    }
    
    @IBAction func playTapped(sender: UIButton) {
        
        if !self.recorder.isRecording {
            do {
                self.player = try AVAudioPlayer(contentsOf: self.getAudioURL() as URL)
                self.player.delegate = self
                self.player.play()
            }
            catch {
                print("Failed to initialize the player.")
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        self.recordPauseButton.setTitle("Record", for: .normal)
        self.playButton.isEnabled = true
        self.stopButton.isEnabled = false
        
        // State model update.
        let model = StateModel.sharedInstance
        model.setRecURL(recordingURL: self.getAudioURL())
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let alert = UIAlertController(title: "Done", message: "Recording completed successfully!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
