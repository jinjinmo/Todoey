//
//  ViewController.swift
//  Todoey
//
//  Created by a2vk on 2018/9/22.
//  Copyright © 2018年 a2vk. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray = ["Find Eggs","Buy Mike","Find Spoon"]
    
      let defaults = UserDefaults.standard //相当新建一个默认对象
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //通过if语句，规避了一些程序上崩溃的bug（也有可能添加的item没有加入数组里面去）
        if let  items  = defaults.array(forKey: "TodoListArray") as? [String]{
           
            itemArray = items
        }
 

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

       cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击后灰色消失，更美观
        tableView.deselectRow(at: indexPath, animated: true)
        //写出复选代码
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFile = UITextField()
      
        
        //写出警示提醒框
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
          //通过提醒框所做出相应的反馈（列表数组需要加载一行，同时页面也需要更新一行）
            self.itemArray.append(textFile.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")//对象的直接调用
          
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Creat new item"
            textFile = alertTextField
        }
        
        
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
        
        
        
        
    }
    
    
    
    
}

