//
//  chatVC.swift
//  Sipenope
//
//  Created by Esther Medina on 11/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import AVKit

class ChatVC: JSQMessagesViewController {
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    let userInfoDAO = DAOFactory.sharedInstance.userInfoDAO
    let messageInfoDAO = DAOFactory.sharedInstance.messageInfoDAO
    
    
    var messages = [JSQMessage]()
    
    var user : User! = User(objectId: "XuTWCdrwIV", name: "jesus@hotmail.com", nickname: "Jesús", email: "jesus@hotmail.com")
    var senderName: String = ""
    var receiverName: String = ""
    var receiverId: String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "MESSAGES"
        
        self.senderName =  (self.userInfoDAO?.getUsernameFromCurrentUser())!
        self.senderId = (self.userInfoDAO?.getObjectidFromCurrentUser())!
        self.senderDisplayName = self.senderName
        self.receiverName = self.user.name
        self.receiverId = self.user.objectId
        
        
        
        let factory = JSQMessagesBubbleImageFactory()
        
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.loadMessages()
     
        
        
    }
    
    
    //MARK: GENERAL
    
    func addMessagePhoto(_ id: String, displayName: String, image: UIImage){
        let photoMedia = JSQPhotoMediaItem(image: image)
        
        let message = JSQMessage(senderId: id, displayName: displayName, media: photoMedia)
        messages.append(message!)
    }
    
    
    
    func addMessage(_ id: String, displayName: String, text: String){
        
        let message = JSQMessage(senderId:id, displayName: displayName, text: text)
        self.messages.append(message!)
        
        
        let receiverId = (id == self.senderId) ? self.receiverId : id
        self.sendNewMessage(senderId: id, receiverId: receiverId, message: text)
        
        
    }
    
    
    private func sendNewMessage(senderId: String, receiverId: String, message: String) {
        self.messageInfoDAO?.setNewMessageInBackground(senderId: senderId, receiverId: receiverId, message: message)
    }
    
    
    func requestMessages(userInfo: [String : Message]) {
       
        let messageInfo = userInfo["messageInfo"]
        //let senderId = (messageInfo?.senderId == receiverId) ? messageInfo?.receiverId : messageInfo?.senderId
        let senderDisplayName = (messageInfo?.senderId == senderId) ? self.senderName : self.receiverName
        
        let message = JSQMessage(senderId: messageInfo?.senderId, senderDisplayName: senderDisplayName, date: messageInfo?.creationDate, text: messageInfo?.message)
        
        self.messages.append(message!)
        
        self.finishReceivingMessage()
        
    }
    
    
    
    private func loadMessages() {
        
        self.messages.removeAll()
        self.messageInfoDAO?.loadMessages(userId: self.senderId, myUserId: (self.user?.objectId)!, withFunction: { (userInfo: [String : Message]) in
            
            self.requestMessages(userInfo: userInfo)
            
        })
        
        self.finishReceivingMessage()

        

    }

    
    //MARK: COLLECTION
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if (cell.textView != nil) {
            if message.senderId == senderId {
                
                cell.textView.textColor = UIColor.white
            }else {
                cell.textView.textColor = UIColor.black
                
            }
        }
        
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        self.addMessagePhoto(senderId, displayName: self.senderDisplayName, image: #imageLiteral(resourceName: "logout"))
        self.finishSendingMessage()
        
    }
    
    
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.addMessage(self.senderId, displayName: self.senderDisplayName, text: text)
        self.finishSendingMessage()
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        }else {
            return incomingBubbleImageView
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        //return JSQMessagesAvatarImage(placeholder: #imageLiteral(resourceName: "logout"))
        return nil
    }
    
}
