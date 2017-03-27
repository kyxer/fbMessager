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
                let entities = ["Friend","Message"]
                
                for entity in entities {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    for object in objects! {
                        context.delete(object)
                    }
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
            
            createMessageWithText(text: "Hello, my name is Mark. Nice to meet you...", friend: mark, minutesAgo: 2, context: context)
            
            createSteveMessagesWithContext(context: context)
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donal Thrump"
            donald.profileImageName = "donald"
            
            createMessageWithText(text: "You are fire!", friend: donald, minutesAgo: 1, context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi"
            
            createMessageWithText(text: "Love, Peace, and Joy!", friend: gandhi, minutesAgo: 24*60, context: context)
            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary"
            
            createMessageWithText(text: "Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 8*24*60, context: context)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
            
            loadData()
        }
        
    }
    
    private func createSteveMessagesWithContext(context:NSManagedObjectContext){
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        
        createMessageWithText(text: "Good morning...", friend: steve, minutesAgo: 3, context: context)
        createMessageWithText(text: "Hello, how are you? Hope you are having good morning", friend: steve, minutesAgo: 2, context: context)
        createMessageWithText(text: "Are you interested in buying an Apple device? We have wide variety that will suit your needs. Please Make your purchase.", friend: steve, minutesAgo: 1, context: context)
        
        createMessageWithText(text: "Yes, totally looking to buy an iPhone 7.", friend: steve, minutesAgo: 1, context: context, isSender: true)
        
        createMessageWithText(text: "Totally understand that you want the new iPhone 7, but you'll have to wait until September for the new release. Sorry but thats just how Apple likes to do things.", friend: steve, minutesAgo: 1, context: context)
        
        createMessageWithText(text: "Absolutely, I'll just use my gigantic iPhone 6 Plus until then!!!", friend: steve, minutesAgo: 1, context: context, isSender: true)
    }
    
    private func createMessageWithText(text:String, friend:Friend, minutesAgo:Double, context:NSManagedObjectContext, isSender:Bool = false){
        let messageSteve = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        messageSteve.friend = friend
        messageSteve.text = text
        messageSteve.date = NSDate().addingTimeInterval(-minutesAgo*60)
        messageSteve.sender = isSender
    
    }
    
    func loadData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            messages = [Message]()
            if let friends = fetchFriends() {
            
                for friend in friends {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                
                    
                    do {
                        if let mess = try(context.fetch(fetchRequest)) as? [Message] {
                            messages.append(contentsOf: mess)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            }
            
            messages = messages.sorted(by: { message1, message2 in
                return message1.date!.compare(message2.date! as Date) == .orderedDescending
            })
            
            
            
        
        }
    }
    
    private func fetchFriends()->[Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                let friends = try context.fetch(fetchRequest) as? [Friend]
                
                return friends
            } catch let err {
                print(err)
            }
        }
        
        return nil
    
    }
    
}
