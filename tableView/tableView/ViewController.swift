//
//  ViewController.swift
//  tableView
//
//  Created by swuad_39 on 27/06/2019.
//  Copyright © 2019 Digital Media Dept. All rights reserved.
//

import UIKit
import FMDB

class ViewController:UIViewController,UITableViewDataSource {
    
    var lottoNumber:[[Int]] = [] //이차원 배열
     var temo_lottoNumber:[[Int]] = []
    @IBOutlet weak var tableView: UITableView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        makeDB()
 
    }
 
    var databasePath:String = ""
    
    func makeDB(){
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        self.databasePath = docsDir + "/lotto.db"
        
        //만약 데이터베이스 파일이 없다면 신규 생성
        if !(fileMgr.fileExists(atPath: self.databasePath)){
            //데이터 베이스 설정
            let db = FMDatabase(path: self.databasePath)
            
            if db.open(){
                let sql_query = "create table if not exists lotto (id integer primary key autoincrement, number1 integer, number2 integer, number3 integer, number4 integer, number5 integer, number6 integer)"
                
                if db.executeStatements(sql_query){
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
    
    
    func lottoDraw(){
        
        //번호 6개 뽑기
        for _ in 0...5{
            var numbers:[Int] = [] //만들때마다 배열 초기화 해줘야됨.
            var count:Int = 0 //6번 다 돌고나서 다시 새로 돌아야되니까 count를 초기화 해주어야함
            
            while count != 6{
                let number = Int.random(in: 1...45) //1부터 45까지 랜덤한 수를 뽑아서 넘버에 넣는다
                //뽑은 수가 number배열에 들어가있지 않으면 추가한다.
                if !numbers.contains(number){
                    numbers.append(number)
                    count += 1
                }
                else{}
            } //numbers에 숫자 6개가 들어감
            numbers.sort(by: {$0 < $1})
            lottoNumber.append(numbers) // numbers가 숫자 6개들어간 배열이니까 반복문 필요없이 numbers 한세트를 이렇게 넣어주면 한번에 들어감
            //근데 그걸 5세트 해줘야됨
            
        } // numbers에 숫자 총 6x5개가 들어감
    }

    //테이블 뷰에 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //한 섹션당 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lottoNumber.count
    }
    //셀 내용 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "lotto cell", for: indexPath) as! LottoCell
        let row = indexPath.row
        
        
        //row = 0,1,2,3,4 //5줄 모두 다른 번호가 나오게
        //여기서 로또번호 출력
        
        cell.number1.text = String(lottoNumber[row][0])
        cell.number2.text = String(lottoNumber[row][1])
        cell.number3.text = String(lottoNumber[row][2])
        cell.number4.text = String(lottoNumber[row][3])
        cell.number5.text = String(lottoNumber[row][4])
        cell.number6.text = String(lottoNumber[row][5])

        return cell
        
    }
    
    
    @IBAction func doLoad(_ sender: UIBarButtonItem) {
        print("load")
        self.lottoNumber = []
        let db = FMDatabase(path: self.databasePath)
        if db.open(){
            let sql_query = "select * from lotto"
            let result: FMResultSet? = db.executeQuery(sql_query, withArgumentsIn: [])
            if result != nil{
                while result!.next(){
                    
                    let temp_array:[Int] = [
                        Int(result!.int(forColumn: "number1")),
                        Int(result!.int(forColumn: "number2")),
                        Int(result!.int(forColumn: "number3")),
                        Int(result!.int(forColumn: "number4")),
                        Int(result!.int(forColumn: "number5")),
                        Int(result!.int(forColumn: "number6"))
                    ]
//                    var temp_array:[Int] = []
//                    var number = Int(result!.int(forColumnIndex: 1))
//                    temp_array.append(number)
                    
                    //데이터에 변수 넣기
                    self.lottoNumber.append(temp_array)
                }
                NSLog("데이터 불러오기 성공")
            } else {
                NSLog("데이터 불러오기 실패")
            }
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func doSave(_ sender: UIBarButtonItem) {
        //self.temo_lottoNumber = self.lottoNumber
        let db = FMDatabase(path: self.databasePath)
        if db.open(){
            //테이블 초기화
            db.executeStatements("delete from lotto")
            if db.hadError(){
                print("삭제 오류")
            }
            
            //첫번째 게임만 저장
            //lottonumbers 변수에 저장된 모든 게임을 데이터베이스에 저장하시오
            for number in lottoNumber{
            let sql_qurey = "insert into lotto(number1, number2, number3, number4, number5, number6) values (\(number[0]), \(number[1]), \(number[2]), \(number[3]), \(number[4]), \(number[5]))"
            
            
            do{
                try db.executeUpdate(sql_qurey, values: nil)
                NSLog("저장 성공")
            }
            catch{
                NSLog("저장 실패")
            }
            
            }}
        print("save")
    }
    
    
    @IBAction func doDraw(_ sender: UIBarButtonItem) {
    
        print("draw")
        self.lottoDraw()
        self.tableView.reloadData()
        
    }
    
    @IBAction func doClear(_ sender: UIBarButtonItem) {
        self.lottoNumber = []
        self.tableView.reloadData()
    }
    
    
  
    
    

}



