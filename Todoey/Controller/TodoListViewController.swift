//
//  ViewController.swift
//  Todoey
//
//  Created by a2vk on 2018/9/22.
//  Copyright © 2018年 a2vk. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
//    //通过使用encode保存数据和保密
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")  //现在不需要这个去保存plist

    var selectedCategory : Category? {
        didSet{
                 loadItem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext//使用数据模型来保存使用数据
      // 现在不使用默认的，为了确保数据的安全性么 let defaults = UserDefaults.standard //相当新建一个默认对象
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        
        //通过if语句，规避了一些程序上崩溃的bug（也有可能添加的item没有加入数组里面去）

//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
     
    }

      //MARK : - TableView Datasource Methods
    
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
        
//        //通过点击直接删除添加的数据
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        
        
        
        //点击后灰色消失，更美观
        tableView.deselectRow(at: indexPath, animated: true)
        //检验没每一行是否已经勾选
        
      itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //更新加载页面，从而使得数据更新  tableView.reloadData()
         self.saveItem()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFile = UITextField()
      
        
        //写出警示提醒框
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textFile.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
          
          //通过提醒框所做出相应的反馈（列表数组需要加载一行，同时页面也需要更新一行）
            self.itemArray.append(newItem)
            
            // 因为不用默认了，所以暂时不需呀的。 self.defaults.set(self.itemArray, forKey: "TodoListArray")//对象的直接调用

            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Creat new item"
            textFile = alertTextField
        }
        
   
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
       
    }
    
    func saveItem(){
//        let encoder = PropertyListEncoder()//建立编码器的永久储存，也就是plist
        //do catch语句是为了测试一下是否可以调用的
        do{
//            let data = try encoder.encode(self.itemArray)//如果出错可能是没有在item添加协议
//            try  data.write(to: self.dataFilePath!)
            try context.save()
            
        }catch{
            print("Error saving context. \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){
        //直接带参数会简洁代码，但是要注意调用时候的参数的使用
       
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
            
        }else {
            request.predicate = categoryPredicate
        }
        
        

        
            do{
                itemArray = try context.fetch(request)

            }catch{
                print("Error fetching data from context\(error)")
            }
           tableView.reloadData()
        }
   
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
      let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)//在文本框输入所需的内容
     
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]//将符合条件的内容安小到大的顺序排序
       
       loadItem(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItem()
            
         DispatchQueue.main.async {// DispatchQueue是主线程用于更新 ui 界面的，退出闪烁光标
           searchBar.resignFirstResponder()//隐藏键盘
            }
           
        }
    }
    
    
}
