//
//  ViewController.swift
//  FireDataBase
//
//  Created by swuad_39 on 03/07/2019.
//  Copyright © 2019 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var IdTextField: UITextField!
    @IBOutlet weak var PasswdTextField: UITextField!
    
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let currentUser = user{
                print("Username", currentUser.displayName)
                
                let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") //main은 스토리보드 id
                
                //만약 네비게이션 컨트롤러 없이 이전화면으로 돌아가고 싶을 때
                //self.dismiss(animated: false, completion: nil) //현재 화면을 끄기 때문에 이전화면으로 돌아간다고 생각하면 됨.
                
                mainViewController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve //스타일 변경
                self.present(mainViewController!, animated: true, completion: nil)
            }else{
                print("not login")
            }
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DoLogin(_ sender: UIButton) {
    
        Auth.auth().signIn(withEmail: "\(self.IdTextField.text!)", password: "\(self.PasswdTextField.text!)")
        {
            [weak self] user, error in
            guard let thisSelf = self else{
                return
            }
            if let error = error{
                print("로그인 에러")
                
                return
            }
            print("로그인 성공")
            //메인 화면으로 이동
            let mainViewController = thisSelf.storyboard?.instantiateViewController(withIdentifier: "main")
            mainViewController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve //스타일 변경
            thisSelf.present(mainViewController!, animated: true, completion: nil)
            
        }
    }
    


}

