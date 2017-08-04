//
//  AddRecodingViewController.swift
//  Sound Board
//
//  Created by Trilok Behere on 8/4/17.
//  Copyright © 2017 Cool Apps. All rights reserved.
//

import UIKit
import AVFoundation


class AddRecodingViewController: UIViewController {
    
    @IBOutlet weak var recordStopButton: UIButton!
    @IBOutlet weak var recodingTitle: UITextField!
    @IBOutlet weak var playButton: UIButton!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        recoderSetup()
        playButton.isEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            //Stop recoding
            audioRecorder?.stop()
            recordStopButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
        } else{
            audioRecorder?.record()
            
            recordStopButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        
        do{
        try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
        audioPlayer!.play()
        } catch{
        
        }
        
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = recodingTitle.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func recoderSetup(){
        
        //Create audio session
        let audioSessions = AVAudioSession.sharedInstance()
        do {
            try audioSessions.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSessions.overrideOutputAudioPort(.speaker)
            try audioSessions.setActive(true)
            
            
            //Create URL for audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //Settings for audio recoder
            
            var audioSettings : [String:Double] =  [:]
            audioSettings[AVFormatIDKey] = Double(kAudioFormatMPEG4AAC)
            audioSettings[AVSampleRateKey] = 44100.0
            audioSettings[AVNumberOfChannelsKey] = 2
            
            //Seup Audio recoder
            
            try audioRecorder = AVAudioRecorder(url: audioURL!, settings: audioSettings)
            
            audioRecorder!.prepareToRecord()
            
        } catch {
            print("error in initialising audio recorder")
        }
    }
}
