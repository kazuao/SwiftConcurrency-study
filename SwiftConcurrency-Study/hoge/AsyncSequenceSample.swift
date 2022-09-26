//
//  AsyncSequenceSample.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/27.
//

import Foundation

class AsyncSequenceSample {

    init() {

        Task {
            let url = URL(string: "https://example.com")!
            let lines = url.lines
                .map { (line: String) -> String in
                    print("[map] ", line)
                    return line.trimmingCharacters(in: .whitespaces)
                }
                .filter { (line: String) -> Bool in
                    print("[fil] ", line)
                    return line.starts(with: "<meta")
                }
                .prefix(2)

            for try await line in lines {
                print("<for> ", line)
            }
            print("\nEnd")
        }
    }
}
