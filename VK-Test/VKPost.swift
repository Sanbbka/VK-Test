//
//  VKPost.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 15.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

class VKPost: NSObject {
    var posts: [NPost] = [NPost]()
    
    func register(_ tableView: UITableView) {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(for: VKPostInfoViewCell.self)
        tableView.registerNib(for: VKPostTextViewCell.self)
        tableView.registerNib(for: VKPostStateViewCell.self)
        tableView.registerNib(for: VKPostPhotoViewCell.self)
    }
}

// MARK: UITableViewDataSource
extension VKPost: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.posts[indexPath.section].items[indexPath.row]
        guard let cell = VKPost.tableView(tableView, cellForRowAt: item)
            else { return UITableViewCell() }
        return cell
    }
}

// MARK: Fabric cells
extension VKPost {
    static func tableView(_ tableView: UITableView, cellForRowAt item: NItemOfPost) -> UITableViewCell? {
        switch item {
        case .info(let name, let date, let avatarLink):
            return getInfoCell(tableView, avatarLink, name, date)
        case .text(let text):
            return getTextCell(tableView, text)
        case .attachment(let attach):
            return getAttachmentCell(tableView, attach)
        case .state(let likes, let comments):
            return getStateCell(tableView, likes, comments)
        }
    }
    
    fileprivate static func getInfoCell(_ tableView: UITableView, _ avatarLink: String, _ name: String, _ date: Date) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: VKPostInfoViewCell.reuseIdentifier) as? VKPostInfoViewCell
        cell?.avatar.kf.setImage(with: URL(string: avatarLink)!)
        cell?.nameLabel.text = name
        cell?.dateLabel.text = "\(date.toStringWithRelativeTime())"
        
        return cell
    }
    
    fileprivate static func getTextCell(_ tableView: UITableView, _ text: (String)) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: VKPostTextViewCell.reuseIdentifier) as? VKPostTextViewCell
        cell?.vkMainText.text = text
        
        return cell
    }
    
    fileprivate static func getAttachmentCell(_ tableView: UITableView, _ attach: (NAttachment)) -> UITableViewCell? {
        switch attach {
        case .photo(let photo):
            let cell = tableView.dequeueReusableCell(withIdentifier: VKPostPhotoViewCell.reuseIdentifier) as? VKPostPhotoViewCell
            cell?.mainImage.image = nil
            cell?.mainImageConstraint.constant = photo.size.height / photo.size.width * tableView.bounds.size.width
            cell?.mainImage.kf.setImage(with: URL(string: photo.link))
            
            return cell
        }
    }
    
    fileprivate static func getStateCell(_ tableView: UITableView, _ likes: NLikes, _ comments: NComments) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: VKPostStateViewCell.reuseIdentifier) as? VKPostStateViewCell
        
        cell?.likesButton.setTitle("\(likes.count)", for: .normal)
        cell?.commentsButton.setTitle("\(comments.count)", for: .normal)
        
        return cell
    }
}
