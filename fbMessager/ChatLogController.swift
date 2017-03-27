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
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(messageInputContainerView)
        
        bottomConstraint = messageInputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
        messageInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageInputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant:0).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor).isActive = true
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
                
            })
        }
    }
    
    private func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        inputTextField.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor).isActive = true
        inputTextField.topAnchor.constraint(equalTo: topBorderView.bottomAnchor).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor, constant:8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        sendButton.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: topBorderView.bottomAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: messageInputContainerView.rightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        topBorderView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor).isActive = true
        topBorderView.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor).isActive = true
        topBorderView.rightAnchor.constraint(equalTo: messageInputContainerView.rightAnchor).isActive = true
        topBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
}

extension ChatLogController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChatLogMessageCell
        let message = messages[indexPath.row]
        if let text = message.text,
            let image = message.friend?.profileImageName {
            
        let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
            cell.profileImageView.image = UIImage(named: image)
            cell.messageTextView.text = text
            
            if message.sender {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                cell.profileImageView.isHidden = true
                //cell.textBubbleView.backgroundColor = UIColor.init(red: 0, green: 134/255, blue: 249/255, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = .white
            } else {
                cell.profileImageView.isHidden = false
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
                //cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = .black
            }
            
            
            
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let text = messages[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let textBubbleView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let i = UIEdgeInsetsMake(22, 26, 22, 26)
        imageView.image = ChatLogMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func setup() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        textBubbleView.addSubview(bubbleImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant:8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        bubbleImageView.topAnchor.constraint(equalTo: textBubbleView.topAnchor).isActive = true
        bubbleImageView.leftAnchor.constraint(equalTo: textBubbleView.leftAnchor).isActive = true
        bubbleImageView.rightAnchor.constraint(equalTo: textBubbleView.rightAnchor).isActive = true
        bubbleImageView.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor).isActive = true
        
    }
}
