//
//  SignUpViewController.swift
//  FireDataBase
//
//  Created by swuad_39 on 03/07/2019.
//  Copyright © 2019 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var IdTextField: UITextField!
    @IBOutlet weak var PasswdTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignupComplete(_ sender: UIButton) {
        print("회원가입 완료")
        Auth.auth().createUser(withEmail: "\(self.IdTextField.text!)", password: "\(self.PasswdTextField.text!)") {
            authResult, error in
            
            guard let authResult = authResult, error == nil else {
                print("회원가입 실패")
                print("오류메시지", error?.localizedDescription)
                return
            }
            // 회원 가입 성공 후 처리 로직
            print("회원가입 성공")
            
            //화면 이동
            //이동할 화면의 인스턴스를 만든다
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") //main은 스토리보드 id
            
            //만약 네비게이션 컨트롤러 없이 이전화면으로 돌아가고 싶을 때
            //self.dismiss(animated: false, completion: nil) //현재 화면을 끄기 때문에 이전화면으로 돌아간다고 생각하면 됨.
            
            mainViewController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve //스타일 변경
            self.present(mainViewController!, animated: true, completion: nil)
            
        }
        
       
        
    }
    
}
