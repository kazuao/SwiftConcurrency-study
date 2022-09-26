//
//  Actor.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/30.
//

import Foundation
import SwiftUI

actor Counter {
    var value = 0

    @discardableResult
    func increment() -> Int {
        value += 1
        return value
    }
}

extension Counter {
    func resetSlowly(to newValue: Int) {
        value = 0
        for _ in 0..<newValue {
            increment()
        }

        assert(value == newValue)
    }
}


actor ImageDownloader {
    private var cache: [URL: Image] = [:]

    func image(from url: URL) async throws -> Image? {
        if let cached = cache[url] {
            return cached
        }

        // サスペンションポイントになっているため、値が変化している可能性がある
        let image = try await downloadImage(from: url)

        // 対策1: キャッシュの有無をもう一度確認する
        // 対策2: Taskを用い、すでに実行中であれば、再実行しないようにする

        cache[url] = image
        return image
    }

    func downloadImage(from: URL) async throws -> Image? {
        return nil
    }
}
