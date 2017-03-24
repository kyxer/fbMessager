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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let text = messages[indexPath.item].text {
            let size = CGSize(width: 180, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 36)
        }
        
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
        backgroundColor = .gray
        messageTextView.topAnchor.constraint(equalTo: topAnchor, constant:8).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: leftAnchor, constant:16).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant:-8).isActive = true
        messageTextView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
    }
}
