//
//  ViewController.swift
//  tableTodo
//
//  Created by swuad_39 on 28/06/2019.
//  Copyright © 2019 Digital Media Dept. All rights reserved.
//

import UIKit
import FMDB

class ViewController: UIViewController ,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var todoText: UITextField!
    var todolist:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    var databasePath:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeDB()
        // Do any additional setup after loading the view.
        
        //불러오기만들기
        
        
    }
    
    func makeDB(){
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        self.databasePath = docsDir + "/todo.db"
        
        //만약 데이터베이스 파일이 없다면 신규 생성
        if !(fileMgr.fileExists(atPath: self.databasePath)){
            //데이터 베이스 설정
            let db = FMDatabase(path: self.databasePath)
            
            if db.open(){
                //todo라는 테이블을 하나 만들거야 거기에 id열에는 정수형이 들어갈거고 todo 열에는 text가 들어갈거야
                let sql_query = "create table if not exists todo (id integer primary key autoincrement, todo text)"
                
                if !db.executeStatements(sql_query){
                    NSLog("테이블 생성 오류")
                } else {
                    NSLog("테이블 생성 성공")
                }
                db.close()
            } else{
                NSLog("디비 연결 오류")
            }
        }else{
            NSLog("디비 있음")
        }
        
    }
    
    @IBAction func SaveButton(_ sender: UIButton) {
        
        //self.todolist.append(self.todoText.text!)
        //self.todoText.text = ""
        //print("저장되었습니다")
        
        self.todoText.resignFirstResponder()
        var content_data = self.todoText.text!
        self.todolist.append(content_data)
        self.todoText.text = ""
        let db = FMDatabase(path: self.databasePath)
        
        if db.open(){
            let sql_query = "insert into todo (todo) values ('\(content_data)')"
            do{
                try db.executeUpdate(sql_query, values: nil)
                NSLog("저장 성공")
            }
            catch{
                NSLog("저장 오류")
            }
        }
        
        
        //테이블 뷰에서 값을 다시 가져오거나 세팅할때 써주어야한다.
        self.tableView.reloadData()
        
    }
    
    
    
    //테이블 뷰에 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //한 섹션당 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todolist.count
    }
    //셀 내용 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo cell", for: indexPath)
        
        let row = indexPath.row
        
        cell.textLabel?.text = "\(row+1). " + todolist[row]
        
        return cell
    }

    //현대 editing이 가능하냐는 함수
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //delete 액션을 하면 실행되는 함수
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let row = indexPath.row
            self.todolist.remove(at: row)
            tableView.reloadData()
        }
        
    }
    //done누르면 키보드 사라지게(아마도?)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.todolist.append(self.todoText.text!)
        self.todoText.text = ""
        self.tableView.reloadData()
        return true
    }

}

