//
//  Posts.swift
//  alamofireProject
//
//  Created by Александр Лебедев on 18.10.2022.
//

import Foundation



class Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}


typealias Posts = [Post]
