//
//  AsyncStream.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/27.
//

import Foundation

//class AsyncStreamSample {
//
//    static var quakes: AsyncStream<Quake> {
//        AsyncStream { continuation in
//            let monitor = QuakeMonitor()
//
//            monitor.quakeHandler { quake in
//                // 値を非同期的に受け取ったら continuation の yield 関数を呼び出すことで
//                // AsyncStream に値が流れる。
//                continuation.yield(quake)
//            }
//
//            monitor.onTermination = { _ in
//                // AsyncStream が終了した後の処理を記述できる。
//                // 引数には、末端まで到達したために終了したのかキャンセルされて終了したのかを
//                // 表す値が入る。
//                // ここでは stopMonitoring 関数を呼び出して監視を終了している。
//                monitor.stopMonitoring
//            }
//
//            monitor.startMonitoring()
//        }
//    }
//
//    func hoge() {
//        for await quake in QuakeMonitor.quakes {
//            // ...
//        }
//    }
//}
