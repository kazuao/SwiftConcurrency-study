import Foundation
import UIKit

//// MARK: 非同期関数から実行
//actor Score {
//    var localLogs: [Int] = []
//    private(set) var highScore: Int = 0
//
//    func update(with score: Int) async {
//        // awaitでの中断中は、他の処理を行ってしまう
//        // 中断の結果、2番目のリクエストが実行されてしまう
////        localLogs.append(score)
////        highScore = await requestHighScore(with: score)
//
//        // この順番にすると期待通りの結果になる
//        highScore = await requestHighScore(with: score)
//        localLogs.append(score)
//    }
//
//    func requestHighScore(with score: Int) async -> Int {
//        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
//        return score
//    }
//}
//
//let score = Score()
//Task.detached {
//    await score.update(with:100)
//    print(await score.localLogs)
//    print(await score.highScore)
//}
//
//Task.detached {
//    await score.update(with:110)
//    print(await score.localLogs)
//    print(await score.highScore)
//}

// MARK: 競合状態の発生2
//actor ImageDownloader {
//    private var cached: [String: UIImage] = [:]
//
//    func image(from url: String) async -> UIImage {
//        if cached.keys.contains(url) {
//            return cached[url]!
//        }
//
//        let image = await downloadImage(from: url)
//
//        // 方法1 取得後に再度チェックする
//        if !cached.keys.contains(url) {
//            cached[url] = image
//        }
//
////        cached[url] = image
//        return cached[url]!
//    }
//
//    func downloadImage(from url: String) async -> UIImage {
//        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
//
//        switch url {
//        case "monster":
//            let imageName = Bool.random() ? "cow" : "fox"
//            return UIImage(named: imageName)!
//
//        default:
//            return UIImage()
//        }
//    }
//}
//
//let imageDownloader = ImageDownloader()

// これだとUIImageの中身が変わってしまうことがある
//Task.detached {
//    let image = await imageDownloader.image(from: "monster")
//    print(image)
//}
//Task.detached {
//    let image = await imageDownloader.image(from: "monster")
//    print(image)
//}

// 順列実行
//Task.detached {
//    let image = await imageDownloader.image(from: "monster")
//    print(image)
//    let image2 = await imageDownloader.image(from: "monster")
//    print(image2)
//}

actor ImageDownloader2 {
    private enum CacheEntry {
        case inProgress(Task<UIImage, Never>)
        case ready(UIImage)
    }

    private var cache: [String: CacheEntry] = [:]

    func image(from url: String) async -> UIImage? {
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image

            case .inProgress(let task):
                // 処理中ならtask.valueで画像を取得
                return await task.value
            }
        }

        let task = Task {
            await downloadImage(from: url)
        }

        // taskをキャッシュに保存
        cache[url] = .inProgress(task)
        let image = await task.value
        cache[url] = .ready(image)
        return image
    }

    func downloadImage(from url: String) async -> UIImage {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)

        switch url {
        case "monster":
            let imageName = Bool.random() ? "cow" : "fox"
            return UIImage(named: imageName)!

        default:
            return UIImage()
        }
    }
}
