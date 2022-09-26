//
//  TaskGroupSample.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/20.
//

import Foundation
import UIKit


class TaskGroupSample {

    struct MyPageInfo {
        let friends: [String]
        let articleTitles: [String]
    }

    // MARK: - Public
    // MARK: TaskGroupを使用する方法
    func fetchMyPageDataUseTaskGroup() async -> MyPageInfo {
        var friends: [String] = []
        var articles: [String] = []

        enum FetchType {
            case friends([String])
            case articles([String])
        }

        // of:で子タスクが返す方を設定
        await withTaskGroup(of: FetchType.self) { group in


            // 1と2は並列で実行される
            // addTaskはescaping
            // 1
            group.addTask { [weak self] in
                let friends = await self?.fetchFriends() ?? []
                return .friends(friends)
            }

            // 2
            group.addTask { [weak self] in
                let articles = await self?.fetchArticles() ?? []
                return .articles(articles)
            }

            // MARK: 1.すべて取得したい場合
//            for await fetchResult in group {
//                switch fetchResult {
//                case .friends(let f):
//                    friends = f
//
//                case .articles(let a):
//                    articles = a
//                }
//            }

            // MARK: 2. Nextで柔軟に使う
            // APIレスポンス結果によって、他の小タスクをキャンセルしたりもできる
            guard let first = await group.next() else {
                group.cancelAll()
                return
            }

            // キャンセルする場合
//            if first... {
//                group.cancelAll()
//            }

            switch first {
            case .friends(let f):
                friends = f

            case .articles(let a):
                articles = a
            }

            guard let second = await group.next() else {
                group.cancelAll()
                return
            }

            switch second {
            case .friends(let f):
                friends = f

            case .articles(let a):
                articles = a
            }
        }

        return MyPageInfo(friends: friends, articleTitles: articles)
    }

    func fetchMyPageDataUseAsyncLet() async -> MyPageInfo {
        async let friends = fetchFriends()
        async let articles = fetchArticles()
        return await MyPageInfo(friends: friends, articleTitles: articles)
    }

    // MARK: エラーのない
    func fetchFriendsAvatars(ids: [String]) async -> [String: UIImage?] {
        return await withTaskGroup(of: (String, UIImage?).self) { group in

            for id in ids {
                group.addTask { [weak self] in
                    return (id, await self?.fetchAvatarImage(id: id))
                }
            }

            var avatars: [String: UIImage?] = [:]
            for await (id, image) in group {
                avatars[id] = image
            }

            return avatars
        }
    }

    // MARK: エラーのある
    func showAllFriends() {
        Task {
            do {
                let friends = try await fetchAllFriends()
                print(friends)
            } catch {
                // 呼び出し元でキャッチ
                print("Error: ", error.localizedDescription)
            }
        }
    }

    func fetchAllFriends() async throws -> [String] {
        return try await withThrowingTaskGroup(of: [String].self) { group in

            group.addTask { [weak self] in
                guard let s = self else { throw InternalError.error }

                return await s.fetchFriends()
            }

            group.addTask { [weak self] in
                guard let s = self else { throw InternalError.error }

                return try await s.fetchFriendsFromLocalDB()
            }

            // fetchFriendsFromLocalDBのエラーが親にも伝播する
            var allFriends: [String] = []
            for try await friends in group {
                allFriends.append(contentsOf: friends)
            }

            return allFriends
        }
    }

    func fetchAllFriendsUseAsyncLet() async throws -> [String] {
        async let friends = fetchFriends()
        async let localFriends = fetchFriendsFromLocalDB() // エラーをthrow
        return try await friends + localFriends
    }



    // MARK: - Private
    private func fetchFriends() async -> [String] {
        await Util.wait(seconds: 3)

        return ["Aris", "Bob", "Cooper", "David",]
    }

    private func fetchArticles() async -> [String] {
        await Util.wait(seconds: 1)
        return ["猫を飼う", "名前はココア", "仕事のじゃま"]
    }

    private func fetchAvatarImage(id: String) async -> UIImage? {
        return UIImage(systemName: "star")
    }

    private func fetchFriendsFromLocalDB() async throws -> [String] {
        await Util.wait(seconds: 1)
        throw InternalError.error
    }
}

struct Util {
    static func wait(seconds: UInt64) async {
        // エラーが発生するとcancellation Errorをthrowする
        try? await Task.sleep(nanoseconds: seconds * NSEC_PER_SEC)
    }
}

enum InternalError: Error {
    case error
}
