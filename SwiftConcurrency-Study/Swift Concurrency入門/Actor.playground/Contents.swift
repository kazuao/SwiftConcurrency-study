import SwiftUI

// MARK: - Data Conflict
// MARK: どちらが先に実行されるかわからない
//class Score {
//    var logs: [Int] = []
//    private(set) var highScore: Int = 0
//
//    func update(with score: Int) {
//        logs.append(score)
//        if score > highScore {
//            highScore = score
//        }
//    }
//}
//
//let score = Score()
//DispatchQueue.global(qos: .default).async {
//    score.update(with: 100)
//    print(score.highScore)
//}
//
//DispatchQueue.global(qos: .default).async {
//    score.update(with: 110)
//    print(score.highScore)
//}

// MARK: シリアルキュー
//class Score {
//    private let serialQueue = DispatchQueue(label: "serial-dispatch-queue")
//    var logs: [Int] = []
//    private(set) var highScore: Int = 0
//
//    func update(with score: Int, completion: @escaping ((Int) -> Void)) {
//        serialQueue.async { [weak self] in
//            guard let s = self else { return }
//
//            s.logs.append(score)
//            if score > s.highScore {
//                s.highScore = score
//            }
//            completion(s.highScore)
//        }
//    }
//}
//
//// 期待通りに動作するが、シリアルキューの作成はボイラープレート
//let score = Score()
//DispatchQueue.global(qos: .default).async {
//    score.update(with: 100) { highScore in
//        print(highScore)
//    }
//}
//
//DispatchQueue.global(qos: .default).async {
//    score.update(with: 110) { highScore in
//        print(highScore)
//    }
//}

// MARK: Actor
//actor Score {
//    var logs: [Int] = []
//    private(set) var highScore: Int = 0
//
//    func update(with score: Int) {
//        logs.append(score)
//        if score > highScore {
//            highScore = score
//        }
//    }
//}
//
//// 期待通りの動作
//let score = Score()
//Task.detached {
//    await score.update(with: 100)
//    print(await score.highScore)
//}
//
//Task.detached {
//    await score.update(with: 110)
//    print(await score.highScore)
//}

// MARK: Actor内の変数は外から直接代入できない
//actor C {
//    var number: Int = 0
//
//    func update(with value: Int) {
//        number = value
//    }
//}
//
//Task.detached {
//    let c = C()
//    await c.number = 1
//    // Actor-isolated property 'number' can not be mutated from a Sendable closure
//}


// MARK: - NonIsolated
// MARK: そのままだとIsolatedになっており、hashableに準拠できない
//actor B: Hashable {
//    let id: UUID = .init()
//    private(set) var number = 0
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    static func == (lhs: B, rhs: B) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func increment() {
//        number += 1
//    }
//}

// MARK: nonIsolatedを付与することで解決できる
// 隔離を解除できる、書込み可能なデータやその操作に対してはつけることができない
//actor B: Hashable {
//    let id: UUID = .init()
//    private(set) var number = 0
//
//    nonisolated func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
////        hasher.combine(number) // これはできない
//    }
//
//    static func == (lhs: B, rhs: B) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func increment() {
//        number += 1
//    }
//}
//
