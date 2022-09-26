//
//  Concurrency.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/11.
//

import Foundation



fileprivate struct Result {
    let user: String
    let icon: String
}

/// 固定処理の並列処理
func concurrency() async {
    // 並列で実行される
    async let user = APIClient.fetchUser(1)
    async let icon = APIClient.fetchUser(2)

    // 各タスクを待つ
    let _: Result = await .init(user: user, icon: icon)
}
