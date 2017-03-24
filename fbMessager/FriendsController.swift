//
//  ViewController.swift
//  fbMessager
//
//  Created by IT-German on 3/21/17.
//  Copyright © 2017 german. All rights reserved.
//

import UIKit

class BaseCell:UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
    }

}

class MessageCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.init(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var message:Message = Message() {
        didSet {
            nameLabel.text = message.friend?.name
            messageLabel.text = message.text
            profileImageView.image = UIImage(named: (message.friend?.profileImageName)!)
            hasReadImageView.image = UIImage(named: (message.friend?.profileImageName)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let date = message.date as! Date
            let elapsedTimeInSeconds = Date().timeIntervalSince(date)
            let secondInDays:TimeInterval = 60 * 60 * 24
            
            if elapsedTimeInSeconds > secondInDays * 7 {
                dateFormatter.dateFormat = "MM/dd/yy"
            } else if elapsedTimeInSeconds > secondInDays {
                dateFormatter.dateFormat = "EEE"
            }
            
            timeLabel.text = dateFormatter.string(from: date)
        }
    
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "zuckeberg")
        return imageView
    }()
    
    let dividerLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mark Zuckenberg"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your friend message and something else..."
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12:09 PM"
        label.textAlignment = .right
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let hasReadImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "zuckeberg")
        return imageView
    }()
    
    override func setup() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(timeLabel)
        addSubview(hasReadImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant:12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant:16).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 68).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 68).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: 4).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:4).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:8).isActive = true
        
        hasReadImageView.rightAnchor.constraint(equalTo: rightAnchor, constant:-8).isActive = true
        hasReadImageView.leftAnchor.constraint(equalTo: messageLabel.rightAnchor, constant:8).isActive = true
        hasReadImageView.topAnchor.constraint(equalTo: messageLabel.topAnchor).isActive = true
        hasReadImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        hasReadImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        dividerLineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellIdentifier = "cellIdentifier"
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = .white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.alwaysBounceVertical = true
        setupData()
        collectionView?.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCell
        cell.message = message
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.friend = messages[indexPath.row].friend
        navigationController?.show(controller, sender: nil)
        
    }


}

