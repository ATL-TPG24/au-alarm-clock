//
//  ViewController.swift
//  clockApp
//
//  Created by Tony Giamboy on 2/4/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    @IBOutlet weak var timeSelect: UIDatePicker!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var buttonText: UIButton!
    
    var timer : Timer?
    var timeLeft : Int?
    var alarm: AVAudioPlayer?
    var clockTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
        timeRemainingLabel.text = ""
        currentTime()
        
        guard let path = Bundle.main.path(forResource: "Alarm", ofType:"wav")
        else {print("not found")
            return}
        let url = URL(fileURLWithPath: path)
        do{
            alarm = try AVAudioPlayer(contentsOf: url)
        }catch{}
    }
    
    
    @IBAction func startTimerButton(_ sender: UIButton) {
        if (buttonText.currentTitle == "Stop Music") {
                    stopMusic()
                    buttonText.setTitle("Start", for: .normal)
                }
                else {
                    let date = timeSelect.date
                    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                    let hour = components.hour!
                    let minute = components.minute!
                    
                    timeLeft = hour * 3600 + minute * 60
                    
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(startCountDown) , userInfo: nil, repeats: true)
                    buttonText.setTitle("Stop Music", for: .normal)
                }
    }
    
    private func getCurrentTime() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }
    @objc func currentTime(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd  yyyy hh:mm:ss"
        currentTimeLabel.text = formatter.string(from: Date())
        let date = Date()
        formatter.dateFormat = "a"
        let ampm = formatter.string(from: date)
        
        if ampm == "AM" {
            // It's AM
            background.image = UIImage(named:"golfSunrise")
        } else {
            // It's PM
            background.image = UIImage(named:"golfDusk")
        }
        
    }
    @objc func startCountDown() {
        if (timeLeft! >= 0) {
            timeRemainingLabel.text = "\(timeLeft!)"
            timeLeft! -= 1
        }
        else {
            playMusic();
        }
    }
        func playMusic() {
            alarm?.play()
        }
        
        func stopMusic() {
            alarm?.pause()
        }
        
    }
