//
//  ViewController.swift
//  CoreDatabase
//
//  Created by swuad_39 on 02/07/2019.
//  Copyright © 2019 Digital Media Dept. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() { //첫 화면이니 항상 메모리가 살아있다.
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadColors()
    }
    

    /*
     어떤 데이터를 저장하기 위해 사용할 수 있는 방법
     1. 기본 변수 담는 방법 : 상태 유지 불가능
     2. 데이터베이스 : FMDB(범용 - query문을 알아야 한다.)
     3. UserDefault : 가벼운 데이터를 저장할 때 편리
     4. CoreData : ios자체적으로 지원해주는 DB 형태
     */
    var colors:[NSManagedObject] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int)-> Int{
        return self.colors.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for : indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = (self.colors[row].value(forKey: "code") as! String)
        return cell

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
              let row = indexPath.row
//            self.colors.remove(at: row)
//            self.tableView.reloadData()
            //여기 까지는 화면에서만 지워진 것 처럼 보임

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.colors[row])
            do{
                try context.save()
            }catch{
                print("삭제 오류")
            }
            self.colors.remove(at: row)
            self.tableView.reloadData()
            
        }
    }
    
    
    @IBAction func addColor(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Color", message: "write favorite Color.", preferredStyle: .alert)
        
        let cancelAction  = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "add", style: .default){
            [unowned self] action in
            guard let textField = alert.textFields?.first, let colorName = textField.text else{
                return
            }
            //self.colors.append(colorName)
            self.saveColor(color: colorName)
            self.tableView.reloadData()
            print(colorName)
            //입력받은 내용을 변수에 추가하기
            //테이블 데이터 reload
        }
        alert.addTextField() // 값 입력받는 텍스트필드
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func saveColor(color:String){
        //1. AppDelegete 찾기
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //2.context 얻기
        let context = appDelegate.persistentContainer.viewContext
        //3.entity 얻기
        let entity = NSEntityDescription.entity(forEntityName: "Color", in: context)!
        //4.오브젝트 만들기
        let color_object = NSManagedObject(entity: entity, insertInto: context)
        //5.context 저장하기
        color_object.setValue(color, forKey: "code")
        do{
            try context.save()
            self.colors.append(color_object)
        } catch {
            NSLog("저장오류")
        }
        self.tableView.reloadData()
    }
    
    func loadColors(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        //data load
        let request = NSFetchRequest<NSManagedObject>(entityName: "Color") //불러와 달라고 요청
        
        do{
            self.colors = try context.fetch(request)
        }catch{
            print("data load error")
        }
        self.tableView.reloadData()
    }

    }
    


