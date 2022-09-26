import SwiftUI


// MARK: - 非同期並列処理
//func waitOneSecond(completion: @escaping (() -> Void)) {
//    sleep(1)
//    completion()
//}
func waitOneSecond() async {
    sleep(1)
}

// MARK: DispatchGroup
func runAsParallel(completionHandler: @escaping (() -> Void)) {
//    let group: DispatchGroup = .init()
//    group.enter()
//    waitOneSecond {
//        group.leave()
//    }
//
//    group.enter()
//    waitOneSecond {
//        group.leave()
//    }
//
//    group.enter()
//    waitOneSecond {
//        group.leave()
//    }
//
//    group.notify(queue: .global()) {
//        completionHandler()
//    }

}

// MARK: AsyncLet
func runAsParallel() async {
    // ここで定義をして
    async let first: Void = waitOneSecond()
    async let second: Void = waitOneSecond()
    async let third: Void = waitOneSecond()

    // ここで実行
    await first
    await second
    await third
}
