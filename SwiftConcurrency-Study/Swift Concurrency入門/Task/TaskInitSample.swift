//
//  TaskInitSample.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/22.
//

import Foundation

private actor A {

    func runTask() {
        let parent = Task(priority: .high) {
            // 子はpriorityを引き継ぐ
            // 子をキャンセルしても親はキャンセルされない
            let child = Task {}
        }
    }
}

@MainActor
private final class TaskDetachedViewModel {

    // MARK: - Public
    func didTapButton() {
        Task {
            // ログ送信など、メインスレッドで実行しなくてもいい処理に利用する
            Task.detached(priority: .low) { [weak self] in
                guard let s = self else { return }

                async let _ = await s.sendLog(name: "didTapButton")
                async let _ = await s.sendLog(name: "user is xxx")
            }

            // これはメインスレッドで実行される
            let user = await fetchUser()
            print(user)
        }
    }

    // 下位にStructured Concurrencyがある場合
    // 下位でもちゃんとキャンセルされる
    var parentTask: Task<Void, Never>?

    func cancelParentTask() {
        Task {
            await TimeTracker.track {
                parentTask = Task.detached {
                    await withTaskGroup(of: Void.self) { group in 

                        group.addTask {
                            await Util.wait(seconds: 2)
                        }

                        for await _ in group {
                            // parentTasがキャンセルしたらこの子タスクもキャンセル
                            print("Finish withTaskGroup")
                        }
                    }

                    // parentTasがキャンセルしたらこの子タスクもキャンセル
                    async let sleep2seconds: ()? = try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
                    await sleep2seconds
                    print("Finish async let")
                }

                parentTask?.cancel()
            }
        }
    }


    // MARK: - Private
    private func sendLog(name: String) async {}

    private func fetchUser() async -> String {
        return "hoge"
    }
}
