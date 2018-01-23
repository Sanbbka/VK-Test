//
//  DetailNewsViewController.swift
//  VK-Test
//
//  Created by Alexandr on 23.01.18.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
 
    var uidPost: String = ""
    
    // tableView dataSource
    private let postsDataSource = VKPost()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Запись"
        self.settingTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
    }
    
    
    // MARK:
    func reloadData() {
        self.db_getData()
    }
    
    func reload(with postItems: [NPost]) {
        self.postsDataSource.posts = postItems
        self.tableView.reloadData()
    }
}


// MARK: Database
extension NewsDetailViewController {
    fileprivate func db_getData() {
        PostMO.getObjects(param: [#keyPath(PostMO.uid): self.uidPost], sort: nil, offset: 0, limit: 1, complete: { [unowned self] (posts: [PostMO]?) in
            guard let posts = posts else { return }
            let arr = posts.map { NPost(with: $0, isDetail: true) }
            
            DispatchQueue.main.async {
                self.reload(with: arr)
            }
        })
    }
}


// MARK: Settings
extension NewsDetailViewController {
    fileprivate func settingTableView() {
        self.tableView.dataSource = self.postsDataSource
        self.postsDataSource.register(self.tableView)
    }
}


// MARK: UITableViewDelegate
extension NewsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
