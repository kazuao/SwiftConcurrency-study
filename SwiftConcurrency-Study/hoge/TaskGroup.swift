//
//  TaskGroup.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/11.
//

import SwiftUI

struct UserNews: Identifiable {
    var id: UUID
    let news: [News]

    struct News: Identifiable {
        let id = UUID()
        let title: String
    }
}

// 可変の非同期処理の並列
struct Challenge2: View {
    @State private var userNews: [UserNews] = []

    var body: some View {
        Button("fetch news by user") {
            Task {
                let userIds = await APIClient.fetchUsers().map(\.id)
                try await withThrowingTaskGroup(of: UserNews.self, body: { group in
                    for userId in userIds {
                        group.addTask {
                            return UserNews(id: userId, news: await APIClient.fetchNews())
                        }
                    }

                    for try await news in group {
                        self.userNews.append(news)
                    }

                    // 単純にすべてを実行する（返り値がVoidの場合）
//                    group.addTask { await hoge() }
//                    group.addTask { await fuga() }
//                    await group.waitForAll()
                })
            }
        }

        Form {
            ForEach(userNews) { userNews in
                Section("\(userNews.id)") {
                    List(userNews.news) { news in
                        Text(news.title)
                    }
                }
            }
        }
    }
}
