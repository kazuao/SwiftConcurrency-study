//
//  TaskCancelSample.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/20.
//

import Foundation
import UIKit

class TaskCancelSample {
    /*
     CancellatinoError: タスクをキャンセル
     Task.checkCancellation: キャンセルマークが付けられた場合に、CancellationErrorをスローする
     Task.isCancelled: タスクがキャンセルマークを付けられたかを判別する
     */

    // MARK: Task.checkCancellation
    func fetchDataWithLongTask() async throws -> [String] {
        return await withThrowingTaskGroup(of: [String].self) { group in

            group.addTask { [weak self] in
                // キャンセルチェック
                try Task.checkCancellation()

                await self?.veryLongTask()
                return ["a", "b"]
            }

            // cancelAllとcheckCancellationを組み合わせることでキャンセルできる
            group.cancelAll()
            return []
        }
    }

    // MARK: Task.isCancelled
    // Task.checkCancellationを使うと、throwしてしまうので、それまでに取得したものをreturnできない
    func fetchIconsWithLongTask(ids: [String]) async throws -> [UIImage] {
        return try await withThrowingTaskGroup(of: UIImage.self) { group in
            for id in ids {
                if Task.isCancelled { break }

                group.addTask { [weak self] in
                    return await self?.fetchImage(with: id) ?? UIImage()
                }
            }

            var icons: [UIImage] = []
            for try await image in group {
                // キャンセルされたら、そこまでに取得した画像を返せる
                icons.append(image)
            }

            return icons
        }
    }

    // MARK: Tracking
    func showNonHandlingCancel() {
        Task {
            await TimeTracker.track {
                await withThrowingTaskGroup(of: Void.self) { group in

                    group.addTask {
                        await Util.wait(seconds: 3)
                    }

                    group.cancelAll()
                }
            }
        }
    }

    func showHandlingCancel() {
        Task {
            await TimeTracker.track {
                await withThrowingTaskGroup(of: Void.self) { group in

                    group.addTask {
                        try Task.checkCancellation()
                        await Util.wait(seconds: 3)
                    }

                    group.cancelAll()
                }
            }
        }
    }


    // MARK: - Private
    private func veryLongTask() async {
        await Util.wait(seconds: 30)
    }

    private func fetchImage(with: String) async -> UIImage {
        await Util.wait(seconds: 10)
        return UIImage(systemName: "star")!
    }
}

struct TimeTracker {
    static func track(_ process: (() async -> Void)) async {
        let start = Date()
        await process()
        let end = Date()
        let span = end.timeIntervalSince(start)
        let doubleDigitSpan = String(format: "%.2f", span)
        print("\(doubleDigitSpan)秒経過")
    }
}


