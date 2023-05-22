//
//  EntriesViewController.swift
//  TopRedditEntries
//
//  Created by Germano Rojas on 21/5/23.
//

import UIKit

class EntriesViewController: UIViewController {
    
    @IBOutlet weak var entriesTableView: UITableView?
    
    private let entriesService: RedditEntriesServiceProtocol = RedditEntriesService()
    
    private var entries: [Post] = []
    private var lastPost: String = ""
    private var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        getTopEntries()
    }
    
    private func setupTable() {
        entriesTableView?.delegate = self
        entriesTableView?.dataSource = self
        entriesTableView?.separatorStyle = .none
        entriesTableView?.registerCells(cell: EntryTableViewCell.self)
    }

    private func getTopEntries(after: String = "") {
        let request: ListingRequest = ListingRequest(count: "1", after: after)
        
        entriesService.getEntries(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                self?.lastPost = response.after ?? ""
                self?.entries.append(contentsOf: response.posts ?? [])
                self?.entriesTableView?.reloadData()
                self?.isLoading = false
            case .failure(let error):
               print(error)
            }
        }
    }

   func loadMoreData() {
       if !self.isLoading {
           self.isLoading = true
           DispatchQueue.global().async {
               sleep(2)
               let start = self.entries.count
               
               let end = start + 10

               if end < 1050 {
                   self.getTopEntries(after: self.lastPost)
               } else {
                   DispatchQueue.main.async {
                       self.isLoading = false
                   }
               }
           }
       }
   }
}

extension EntriesViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let offsetY = scrollView.contentOffset.y
       let contentHeight = scrollView.contentSize.height

       if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
           loadMoreData()
       }
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry: Post = entries[indexPath.row]
        
        guard
            let cell = tableView.getEntryCell(for: indexPath)
            else {
                fatalError("Cell or datasource is not properly setup")
        }
        cell.entry = entry
        cell.setupView()
        return cell
        
    }
}

private extension UITableView {
    func registerCells(cell: UITableViewCell.Type) {
        let name = String(describing: cell)
        let nib = UINib(nibName: name, bundle: Bundle(for: cell))
        register(nib, forCellReuseIdentifier: name)
    }
    
    func getEntryCell(for indexPath: IndexPath) -> EntryTableViewCell? {
        let name = String(describing: EntryTableViewCell.self)
        
        return dequeueReusableCell(withIdentifier: name, for: indexPath) as? EntryTableViewCell
    }
}

