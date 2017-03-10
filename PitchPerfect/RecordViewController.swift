//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Milad Nozari on 3/10/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButtonWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var audioRecorder: AVAudioRecorder?
    struct Storyboard {
        static let recordToPlaySegue = "recordToPlay"
        static let recordButtonNormalSize: CGFloat = 128
        static let recordButtonSmallSize: CGFloat = 96
        static let elementsSizeInLowerHalfOfScreen: CGFloat = 189
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // add an observer so that we can detect orientation changes
        // and set the size of the record button if there isn't enough
        // space.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(RecordViewController.orientationChanged),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.recordToPlaySegue {
            let audioUrl = sender as! URL
            let playViewController = segue.destination as! PlayViewController
            playViewController.audioUrl = audioUrl
        }
    }

    // MARK: - IBActions
    @IBAction func record(_ sender: UIButton) {
        recordLabel.text = "Recording..."
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let fileName = "recording.wav"
        let pathArray = [documentsDir, fileName]
        let filePath = URL(string: pathArray.joined(separator: "/"))!
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        audioRecorder = try! AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }

    @IBAction func stop(_ sender: UIButton) {
        recordLabel.text = "Tap to Record"
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        
        audioRecorder?.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    // MARK: - public functions
    func orientationChanged() {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            recordButtonWidthConstraint.constant = Storyboard.recordButtonNormalSize
        }
        else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            if view.frame.size.height / 2 < Storyboard.elementsSizeInLowerHalfOfScreen {
                recordButtonWidthConstraint.constant = Storyboard.recordButtonSmallSize
            }
        }
    }
}

// MARK: - AVAUdioRecorderDelegate
extension RecordViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: Storyboard.recordToPlaySegue, sender: recorder.url)
        }
        else {
            print("Audio recording failed!")
        }
    }
    
}

