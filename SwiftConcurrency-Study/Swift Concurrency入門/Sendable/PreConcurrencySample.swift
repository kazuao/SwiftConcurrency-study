//
//  PreConcurrencySample.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/23.
//

import Foundation


// MARK: - 関数と使う
// MainActorやSendableを付与した関数
@MainActor
public func doSomething(_ body: @Sendable @escaping () -> Void) {
    Task.detached {
        body()
    }
}

// preconcurrencyを付与
@preconcurrency
@MainActor
public func doSomethingPreConcurrency(_ body: @Sendable @escaping () -> Void) {
    Task.detached {
        body()
    }
}

class MyButtonInteraction {

    // Sendableではない型
    class MyCounter {
        var value = 0

        func onClick(counter: MyCounter) {

            // 普通に使うとコンパイルエラー
//            doSomething {
//                print("tapped")
//                counter.value += 1 // warning
//            }

            // 利用者側でコード修正を矯正させる場合
//            Task {
//                await doSomething {
//                    print("tapped")
//                    // counter.value += 1 // これを使うにはMyCounterをSendableにする必要がある
//                }
//            }

            // 利用者側に矯正させない場合
            // もとのコードに@preconcurrencyを付与し、使用側で対応していない場合、@MainActorや@Sendableを使用しないようにする
            doSomethingPreConcurrency {
                print("tapped")
                counter.value += 1
            }
        }

        func onClickAsync(counter: MyCounter) async {
            // 非同期関数から呼び出す場合は、preconcurrencyが無視される
            await doSomethingPreConcurrency {
                print("tapped")
//                counter.value += 1 // warning
            }
        }
    }
}


// MARK: - Importと使う
// Sendableに準拠していない別モジュール
public struct Point {
    public var x: Double
    public var y: Double
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

// 付与することで、Sendableチェックをなくす
//@preconcurrency
//import HogeHoge

// 呼び出し側
@MainActor
final class Animator {
    var currentPoint: Point = .init(x: 0.0, y: 0.0)

    func centerView(at location: Point) {
        Task {
            let _ = await makeCenter(current: currentPoint, to: location) // warning
        }
    }

    private func makeCenter(current: Point, to: Point) async -> Double {
        return 0.0
    }
}
