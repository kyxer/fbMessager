//
//  ChatLogController.swift
//  fbMessager
//
//  Created by IT-German on 3/24/17.
//  Copyright © 2017 german. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var friend:Friend?{
        didSet {
            navigationItem.title = friend?.name
        
            if let mess = friend?.message?.allObjects as? [Message] {
                messages = mess
                messages = messages.sorted(by: { message1, message2 in
                    return message1.date!.compare(message2.date! as Date) == .orderedAscending})
            }
        }
    }
    var messages:[Message] = []
    let cellIdentifier = "cellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension ChatLogController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChatLogMessageCell
        cell.messageTextView.text = messages[indexPath.row].text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func setup() {
        addSubview(messageTextView)
        
        messageTextView.topAnchor.constraint(equalTo: topAnchor, constant:8).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: rightAnchor, constant:-16).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant:-8).isActive = true
        messageTextView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        backgroundColor = .red
    }
}
