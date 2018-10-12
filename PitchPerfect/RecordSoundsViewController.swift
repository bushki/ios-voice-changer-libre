//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Luis on 2/7/18.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        //get directory to store file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        //create file path
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        
        //start and config AV session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        //start recorder try! mean no errors will be handled
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord() //Creates an audio file and prepares the system for recording.
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //this func is part of the AVAudioRecorderDelegate protocol (interface)
    //will get called when audio has finished recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //print("finished recording")
        if(flag)
        {
            //performe segue and send file URL using the audioRecorder variable
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        }
        else
        {
            print("recording was not successful")
        }
    }
    
    //gets called right befor the segue happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check to make sure the segue ID is correct
        if segue.identifier == "stopRecordingSegue"
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController //get the destination view controller
            let recorderAudioURL = sender as! URL  //get the recorded file URL
            playSoundsVC.recordedAudioURL = recorderAudioURL; //set the varible in the target VC to have the file URL
        }
    }
    
    
}

