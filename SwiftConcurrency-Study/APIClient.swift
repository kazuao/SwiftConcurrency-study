//
//  APIClient.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/11.
//

import Foundation

struct User: Identifiable {
    let id = UUID()

}

class APIClient {
    static func fetchUser(_ by: Int) async -> String {
        return  ""
    }

    static func fetchUsers() async -> [User] {
        return [User(), User()]
    }

    static func fetchNews() async -> [UserNews.News] {
        return [.init(title: "hoge"), .init(title: "fuga")]
    }
}
