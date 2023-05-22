//
//  EntryTableViewCell.swift
//  TopRedditEntries
//
//  Created by Germano Rojas on 21/5/23.
//

import Foundation
import UIKit
import SDWebImage

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView?
    @IBOutlet weak var entryImageView: UIImageView?
    @IBOutlet weak var entryTitle: UILabel?
    @IBOutlet weak var entryAuthor: UILabel?
    @IBOutlet weak var entryDate: UILabel?
    @IBOutlet weak var entryCommentsCount: UILabel?
    @IBOutlet weak var entrySubreddit: UILabel?
    
    var entry: Post?
    
    // MARK: Private functions
    func setupView() {
        
        entryImageView?.sd_setImage(with: URL(string: entry?.thumbnail ?? ""), placeholderImage: UIImage(named: entry?.id ?? ""))
        
        entryTitle?.text = entry?.title
        entryTitle?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        entryAuthor?.text = "Author: \(entry?.author ?? "")"
        entryAuthor?.font = UIFont.systemFont(ofSize: 14.0)
        
        entryDate?.text = "Date: \(entry?.date ?? "")"
        entryDate?.font = UIFont.systemFont(ofSize: 14.0)
        
        entryCommentsCount?.text = "Comments: \(String(entry?.numComments ?? 0))"
        entryCommentsCount?.font = UIFont.systemFont(ofSize: 14.0)
        
        entrySubreddit?.text = "Subredit: \(entry?.subreddit ?? "")"
        entrySubreddit?.font = UIFont.systemFont(ofSize: 14.0)
        
        viewContainer?.layer.borderWidth = 1
        viewContainer?.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        viewContainer?.layer.cornerRadius = 8

    }
    
    @IBAction func onActionButtonPressed(_ sender: Any) {
        return
    }
}
