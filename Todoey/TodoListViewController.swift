//
//  ViewController.swift
//  Todoey
//
//  Created by a2vk on 2018/9/22.
//  Copyright © 2018年 a2vk. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    let itemArray = ["Find Eggs","Buy Mike","Find Spoon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
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
    
    
    
}

