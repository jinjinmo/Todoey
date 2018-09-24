//
//  ViewController.swift
//  Todoey
//
//  Created by a2vk on 2018/9/22.
//  Copyright © 2018年 a2vk. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    
    
    
      let defaults = UserDefaults.standard //相当新建一个默认对象
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //通过if语句，规避了一些程序上崩溃的bug（也有可能添加的item没有加入数组里面去）
        if let  items  = defaults.array(forKey: "TodoListArray") as? [String]{

            itemArray = items
        }
        
        let newItem = Item()
        newItem.title = "asd"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "qwe"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "zxc"
        itemArray.append(newItem3)
        

        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        //通过代接 缩短 简洁 代码
        let  item = itemArray[indexPath.row]
       cell.textLabel?.text = item.title
   
        
        //写出复选代码(三目运算符)
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
    }

   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击后灰色消失，更美观
        tableView.deselectRow(at: indexPath, animated: true)
        //检验没每一行是否已经勾选
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //更新加载页面，从而使得数据更新
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFile = UITextField()
      
        
        //写出警示提醒框
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textFile.text!
            
          
          //通过提醒框所做出相应的反馈（列表数组需要加载一行，同时页面也需要更新一行）
            self.itemArray.append(newItem)
            
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

