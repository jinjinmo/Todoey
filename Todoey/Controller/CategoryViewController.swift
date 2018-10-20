//
//  CategoryViewController.swift
//  Todoey
//
//  Created by a2vk on 2018/10/15.
//  Copyright © 2018年 a2vk. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //配置文件属性
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
     
        cell.textLabel?.text = categories[indexPath.row].name
        
        
        return cell
    }
    
        //MARK: - Tableview Delegate Methods
    
    //告诉委托者代理指定行
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //使用当前代理进行页面的跳转
        performSegue(withIdentifier: "goToItems", sender: self)
     
    }
     //MARK: - Add New Category(以及进行托管)
    @IBAction func addBUttonPressed(_ sender: UIBarButtonItem) {
        
        
        
        var textFile = UITextField()
        
        let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in//这里是对新对象的信息托管
            
            let newCategory = Category(context: self.context)
            newCategory.name = textFile.text
            
            //接下来在开始数据的持久存储
            self.categories.append(newCategory)
            
            self.saveCategroies()
            
            
        }
        
        
        alert.addTextField { (field) in
            textFile = field
            textFile.placeholder = "Add a new catagory"//这个是提示语
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)//数据托管
    }
    
  //通知controller即将执行segue跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
    }
    
    }
    
    //MARK: - Data Maniplution  Methods
    func saveCategroies() {
        do{
            try context.save()
            
        }catch{
            print("Error saving category. \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategories() {
    
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try context.fetch(request)
            
        }catch{
            print("Error fetching data from context\(error)")
        }
        tableView.reloadData()
    }
   
    
    
    
    
    

 
    
    
    
    
    
    
    }


