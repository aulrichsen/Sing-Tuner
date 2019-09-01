//
//  ViewController.swift
//  Sing Tuner
//
//  Created by Alexander Ulrichsen on 29/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    

    //Used to change title and enablement of the buttons
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var filename : String = "audioFile.m4a"
    
    let notes = ["A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab"]
    
    @IBOutlet weak var recordOutlet: UIButton!
    
    @IBOutlet weak var playOutlet: UIButton!
    
    
    @IBOutlet weak var notePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupRecorder()
        playOutlet.isEnabled = false
        
        notePicker.delegate = self
        notePicker.dataSource = self
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK: - Recorder and Player setup methods
    
    func setupRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)
        let recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue, AVEncoderBitRateKey: 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey :44100.2] as [String : Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()     //Creates a sound file and prepares the system for recording
        } catch {
            print("Audio setup error, \(error)")
        }
    }
    
    func setupPlayer() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            
        } catch {
            print("Player setup error, \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playOutlet.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordOutlet.isEnabled = true
        playOutlet.setTitle("Play", for: .normal)
    }
    
    
    //MARK: - UIPickerView required delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notes[row]
    }
    
    
    @IBAction func recordPressed(_ sender: Any) {
        if recordOutlet.titleLabel?.text == "Record" {
            soundRecorder.record()
            recordOutlet.setTitle("Stop", for: .normal)
            playOutlet.isEnabled = false
        }
        else {
            soundRecorder.stop()
            recordOutlet.setTitle("Record", for: .normal)
            playOutlet.isEnabled = true
        }
    }
    
    
    @IBAction func playPressed(_ sender: Any) {
        
        if playOutlet.titleLabel?.text == "Play" {
            playOutlet.setTitle("Stop", for: .normal)
            recordOutlet.isEnabled = false
            setupPlayer()
            soundPlayer.play()
            
        }
        else {
            soundPlayer.stop()
            playOutlet.setTitle("Play", for: .normal)
            recordOutlet.isEnabled = true
        }
    }
    

}

