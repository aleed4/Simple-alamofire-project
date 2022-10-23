//
//  NetworkManager.swift
//  alamofireProject
//
//  Created by Александр Лебедев on 18.10.2022.
//

import UIKit
import Alamofire


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getPosts(completion: @escaping (Posts) -> Void) {
        DispatchQueue.global().async {
            AF.request("https://jsonplaceholder.typicode.com/posts", method: .get).validate().responseDecodable(of: Posts.self) { response in
                switch response.result {
                case .success(let posts):
                    completion(posts)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
       
    }
    
    func deletePost(indexPath: Int) {
        AF.request("https://jsonplaceholder.typicode.com/posts/\(indexPath)", method: .delete)
        print("post \(indexPath) delete from server")
    }
    
}
