//
//  ViewController.swift
//  CheckClock
//
//  Created by swuad_34 on 01/07/2019.
//  Copyright © 2019 swuad_34. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet var h1: UIImageView!
    @IBOutlet var h2: UIImageView!
    @IBOutlet var hour: UIImageView!
    
    @IBOutlet var m1: UIImageView!
    @IBOutlet var m2: UIImageView!
    @IBOutlet var m3: UIImageView!
    @IBOutlet var minute: UIImageView!
    
    @IBOutlet var s1: UIImageView!
    @IBOutlet var s2: UIImageView!
    @IBOutlet var s3: UIImageView!
    @IBOutlet var second: UIImageView!
    
    @IBOutlet var current_time_label: UILabel!
    
    var switch_value:Bool = false
    
    override func viewWillAppear(_ animated: Bool) { //화면이 보이려고 하면 매번 실행됨.
        super.viewWillAppear(animated)
        print("view will appear")
        
        //userdefault를 사용해서 값불러오기
        guard let switch_value_object = UserDefaults.standard.object(forKey: "switch_value") else{
            return
        }
        self.switch_value = switch_value_object as! Bool
        
    }
    
    override func viewDidLoad() { //앱이 한번 켜지면 딱 한번만 실행됨
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTimeLabel()
        
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTimeLabel), userInfo: nil, repeats: true)

        // 1. Label -> UIImageView 교체
        // 2. setTimeLabel 함수의 내용을 한글->이미지로 교체
    }
    
    @objc func setTimeLabel() {
        // 현재 시간 불러오기
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        print(components.hour, components.minute, components.second)
        
        let current_hour = components.hour! < 12 ? components.hour! : components.hour!-12
        let current_min = components.minute!
        let current_sec = components.second!
        
        let hours = ["영","한","두","세","네","다섯","여섯","일곱","여덟","아홉","열","열한","열두"]
        let numbers = ["영","일","이","삼","사","오","육","칠","팔","구","십"]
        
        // 1. 적당히 글자 끊어서 넣어주기
        // 글자가 두자리이냐 아니냐에 따라서 분기
        if ( hours[current_hour].count > 1 ) {
            h1.image = UIImage(named: "\(hours[current_hour].first!)")
            h2.image = UIImage(named: "\(hours[current_hour].last!)")
        } else {
            h1.image = UIImage()
            h2.image = UIImage(named: "\(hours[current_hour])")
        }
        hour.image = UIImage(named: "시")
        
        // 숫자가
        if ( current_min <= 10) {
            m1.image = UIImage()
            m2.image = UIImage()
            m3.image = UIImage(named: "\(numbers[current_min])")
        } else if ( current_min < 20 ){
            m1.image = UIImage()
            m2.image = UIImage(named: "\(numbers[10])")
            m3.image = UIImage(named: "\(numbers[current_min % 10])")
        } else {
            if current_min % 10 == 0 {
                m1.image = UIImage()
                m2.image = UIImage(named: "\(numbers[current_min / 10])")
                m3.image = UIImage(named: "\(numbers[10])")
            } else {
                m1.image = UIImage(named: "\(numbers[current_min/10])")
                m2.image = UIImage(named: "\(numbers[10])")
                m3.image = UIImage(named: "\(numbers[current_min % 10])")
            }
        }
        minute.image = UIImage(named: "분")
        
        if current_sec <= 10 {
            s1.image = UIImage()
            s2.image = UIImage()
            s3.image = UIImage(named: "\(numbers[current_sec])")
        } else if current_sec < 20 {
            s1.image = UIImage()
            s2.image = UIImage(named: "\(numbers[10])")
            s3.image = UIImage(named: "\(numbers[current_sec%10])")
        } else {
            if current_sec % 10 == 0 {
                s1.image = UIImage()
                s2.image = UIImage(named: "\(numbers[current_sec/10])")
                s3.image = UIImage(named: "\(numbers[10])")
            } else {
                s1.image = UIImage(named: "\(numbers[current_sec/10])")
                s2.image = UIImage(named: "\(numbers[10])")
                s3.image = UIImage(named: "\(numbers[current_sec % 10])")
        }
    }
        second.image = UIImage(named: "초")
        
        let timestamp = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        
        if self.switch_value /*|| (Locale.preferredLanguages[0].range(of: "ko") == nil*/ { // .range(of: "ko") == nil
            self.current_time_label.text = timestamp
        } else {
            self.current_time_label.text = ""
        }
        


}
}
