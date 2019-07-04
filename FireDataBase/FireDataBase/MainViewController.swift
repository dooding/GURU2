//
//  MainViewController.swift
//  FireDataBase
//
//  Created by swuad_39 on 03/07/2019.
//  Copyright © 2019 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser
        if let user = user{
            print(user.uid, user.email, user.displayName)
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier:"login")
            
            loginViewController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(loginViewController!, animated: true, completion: nil)
            
        } catch {
            print("로그아웃 실패")
        }
        
    }
    
    @IBAction func changeName(_ sender: Any) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = self.displayNameTextField.text
        changeRequest?.commitChanges{
            (error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                print("변경 성공")
            }
        }
        
    }
    
    
    
    
}
