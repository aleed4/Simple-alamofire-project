//
//  PostsViewController.swift
//  alamofireProject
//
//  Created by Александр Лебедев on 17.10.2022.
//

import UIKit
import Alamofire

class PostsViewController: UITableViewController {
    
    var posts = Posts()
    var filteredPosts : Posts?
    
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPosts))
        title = "Posts"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        
        self.tableView.keyboardDismissMode = .onDrag
        
        NetworkManager.shared.getPosts { posts in
            DispatchQueue.main.async {
                self.posts = posts
                self.tableView.reloadData()
            }
          
        }
        
        }

    
    @objc func refreshPosts()  {
        filteredPosts = nil
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredPosts == nil ? posts.count : filteredPosts!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let post = filteredPosts == nil ? posts[indexPath.row] : filteredPosts![indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if filteredPosts == nil {
                posts.remove(at: indexPath.row)
            } else {
                filteredPosts?.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            NetworkManager.shared.deletePost(indexPath: indexPath.row + 1)
        }
    }

}


//MARK: PostsViewController extension

extension PostsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            filteredPosts = posts
            filteredPosts = filteredPosts?.filter{ $0.title.lowercased().contains(text.lowercased()) || $0.body.lowercased().contains(text.lowercased()) }
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredPosts = nil
        tableView.reloadData()
    }
}
