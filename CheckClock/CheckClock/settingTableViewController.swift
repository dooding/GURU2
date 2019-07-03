//
//  settingTableViewController.swift
//  CheckClock
//
//  Created by swuad_39 on 02/07/2019.
//  Copyright © 2019 swuad_34. All rights reserved.
//

import UIKit

class settingTableViewController: UITableViewController {
    
    @IBOutlet weak var onoffswich: UISwitch!
    
    
    override func viewWillAppear(_ animated: Bool) { //화면이 보이려고 하면 매번 실행됨.
        super.viewWillAppear(animated)
        print("view will appear")
        
        //userdefault를 사용해서 값불러오기
    //onoffswich.isOn = UserDefaults.standard.bool(forKey: "switch_value")
        
        guard let switch_value_object = UserDefaults.standard.object(forKey: "switch_value") else{
            return
        }
        /*
         gurad let 변수명 = 옵셔널 값 else{
         옵셔널 값이 nil일 경우에 실행구문
         return
         }
         */
        self.onoffswich.isOn = switch_value_object as! Bool
        
       
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: "switch_value")
       
        
        //실제로 파일에 저장하기
        UserDefaults.standard.synchronize()
        
//        //sample이라는 키값에 test라는 문자열 저장하기
//        UserDefaults.standard.set("test", forkey : "sample")
//        UserDefaults.standard.set(true, forKey: "sample_bool")
//
//        //저장된 값 불러오기
//        UserDefaults.standard.bool(forKey: "sample_bool")
//        UserDefaults.standard.string(forKey: "sample")
//
//        //값이 있나 확인하기
//        if UserDefaults.standard.object(forKey: "sample") != nil{
//
//        }
    }
    
}
