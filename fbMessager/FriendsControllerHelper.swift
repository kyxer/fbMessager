//
//  FriendsControllerHelper.swift
//  fbMessager
//
//  Created by IT-German on 3/21/17.
//  Copyright © 2017 german. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    
    func clearData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    context.delete(object)
                }
                
                try(context.save())
                
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func setupData(){
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckeberg"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = mark
            message.text = "Hello, my name is Mark. Nice to meet you..."
            message.date = NSDate()
            
            let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            steve.name = "Steve Jobs"
            steve.profileImageName = "steve"
            
            let messageSteve = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            messageSteve.friend = steve
            messageSteve.text = "Apple create great iOS Devices for the world..."
            messageSteve.date = NSDate()
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
            
            loadData()
        }
        
    }
    
    func loadData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            do {
                if let mess = try(context.fetch(fetchRequest)) as? [Message] {
                    messages = mess
                }
            } catch let err {
                print(err)
            }
            
        
        }
    }
    
}
