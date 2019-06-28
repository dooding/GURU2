//
//  ViewController.swift
//  musicPlay
//
//  Created by SWUCOMPUTER on 26/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

//"Music: www.bensound.com"

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    //하나의 뷰당 하나의 뷰 컨트롤러가 필요하다.
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var progressSlider: UISlider!
    
    var player:AVAudioPlayer!
    var time:Timer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initilalize()
    }
   
        
    func initilalize(){
        
        guard let soundAsset:NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 없음")
            return
        }
        do{
            try self.player = AVAudioPlayer(data:soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError{
            print("음악 플레이어 초기화 오류")
        }
        
        self.timeLabel.text = "00:00:00"
        self.progressSlider.minimumValue = 0.0
        self.progressSlider.maximumValue = Float(self.player.duration)
        self.progressSlider.value = Float(self.player.currentTime)
        
    }
        
    func makeandFireTimer(){
        self.time = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[unowned self] (timer:Timer) in
            if (self.progressSlider.isTracking){ return }
            self.updateTimeLabelText(with: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.time.fire() //타이머 시작
    }
    
    func invalidateTimer(){ //타이머 끝내려면 호출
        self.time.invalidate()
        self.time = nil
    }
        
        
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        /*
         if sender.isSelected
         {
            sender.isSelected = false
         }
         else{
            sender.isSelected = true
         }
         */
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected //재생
        {
            self.player?.play()
            self.makeandFireTimer()
        }
        else{ //중지
            self.player?.pause()
            self.invalidateTimer()
        }
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        NSLog("\(sender.value)")
        self.updateTimeLabelText(with: TimeInterval(sender.value))
        if sender.isTracking{ return } //움직이는 와중이면 아무것도 안함
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    
    
    func updateTimeLabelText(with time:TimeInterval)
    {
        let min:Int = Int(time / 60)
        let sec:Int = Int(time.truncatingRemainder(dividingBy: 60))
        let msec:Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        //%02는 두자리, ld는 십진수
        let timeText:String = String(format: "%02ld:%02ld:%02ld", min, sec, msec)
        self.timeLabel.text = timeText
    }
        
        
        
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        
    }
        
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag : Bool)
    {
        //음악이 끝까지 재생되었을때
        /*
         1. 재생버튼으로 바꾸기
         2. 슬라이더의 위치 0으로 만들기
         3. 테이블 시간도 0으로 만들기
         4. 타이머끄기
         */
        
        playPauseButton.isSelected = false
        progressSlider.value = 0
        self.timeLabel.text = "00:00:00"
        self.time.invalidate()
        
    }
        
}

