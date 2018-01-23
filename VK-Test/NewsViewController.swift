//
//  NewsViewController.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit
import ESPullToRefresh
import Kingfisher
import PKHUD

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // tableView dataSource
    let postsDataSource = VKPost()
    
    private var startFtom: String {
        return ud_getValue(forKey: .postVKstartFrom) as? String ?? ""
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingTableView()
        self.setupTableActions()
        
        self.reloadData()
    }
    
    // MARK: Actions
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.askConfirmLogout()
    }
    
    // MARK:
    func reloadData() {
        self.db_getData()
    }
    
    func reload(with postItems: [NPost]) {
        self.postsDataSource.posts = postItems
        self.tableView.reloadData()
    }
    
    
    fileprivate func setupTableActions() {
        tableView.es.addPullToRefresh {
            [unowned self] in
            self.apiReloadData()
        }
        
        tableView.es.addInfiniteScrolling {
            [unowned self] in
            self.apiLoadMore()
        }
        
        if self.startFtom.count == 0 {
            tableView.es.startPullToRefresh()
        }
    }
}


// MARK: Settings
extension NewsViewController {
    fileprivate func settingTableView() {
        self.tableView.dataSource = self.postsDataSource
        self.postsDataSource.register(self.tableView)
    }
}


// MARK: Action
extension NewsViewController {
    fileprivate func askConfirmLogout() {
        requestConfirmActionOfUser(with: "Вы действительно хотите выйти?") { [unowned self] (isConfirm) in
            if isConfirm {
                self.logout(completion: nil)
            }
        }
    }
    
    fileprivate func logout(completion:  ((Bool)->())?) {
        AppWireframe.shared.userLogout(completion: completion)
    }
}


// MARK: Database
extension NewsViewController {
    fileprivate func db_getData() {
        PostMO.getObjects (sort: [#keyPath(PostMO.date): false]) { [unowned self] (posts: [PostMO]?) in
            guard let posts = posts else { return }
            let arr = posts.map { NPost(with: $0, isDetail: false) }
            
            DispatchQueue.main.async {
                self.reload(with: arr)
            }
        }
    }
}


// MARK: UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10))
        header.backgroundColor = Consts.AppColors.lightGrayColor
        header.layer.borderWidth = 0.5
        header.layer.borderColor = UIColor.lightGray.cgColor
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.postsDataSource.posts[indexPath.section]
        let vc = StoryboardHelper.newsDetailScreen()
        if let detail = vc as? NewsDetailViewController {
            detail.uidPost = item.uid
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
}


// MARK: API
extension NewsViewController {
    fileprivate func apiLoadMore() {
        self.apiGetNews(at: self.startFtom) { [unowned self] in
            self.tableView.es.stopLoadingMore()
        }
    }
    
    fileprivate func apiReloadData() {
        self.apiGetNews(at: "") { [unowned self] in
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    fileprivate func apiGetNews(at start: String, complete:@escaping ()->()) {
        APIVKNews.getNews(at: start) { [unowned self] (error) in
            switch error {
            case .none:
                self.reloadData()
            case .authError(let msg):
                self.userAuthError(with: msg)
            case .undefinedError(let msg):
                print(msg)
            case .networkError:
                print("network error")
            }
            complete()
        }
    }
    
    fileprivate func userAuthError(with message: String) {
        self.logout { (_) in
            HUD.flash(.label(message), delay: 3)
        }
    }
}
