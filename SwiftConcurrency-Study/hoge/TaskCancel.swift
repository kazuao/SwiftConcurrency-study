//
//  TaskCancel.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/27.
//

import Foundation
import UIKit

//class TaskCancel {
//
//    func fetchThumbnails(for ids: [String ]) async throws -> [String: UIImage] {
//        var thumbnails: [String: UIImage] = [:]
//
//        for id in ids {
////            try Task.checkCancellation() // キャンセルされている場合は、throwする
//            if Task.isCancelled { break } // キャンセルされている場合、breakする
//            thumbnails[id] = try await fetchOneThumbnail(withID: id)
//        }
//        return thumbnails
//    }
//
//    func download(url: URL) async throws -> Data? {
//        var urlSessionTask: URLSessionTask?
//
//        return try await withTaskCancellationHandler {
//
//            return try await withUnsafeThrowingContinuation { continuation in
//                urlSessionTask = URLSession.shared.dataTask(with: url) { data, _, error in
//                    if let error = error {
//                        // 理想的には NSURLErrorCancelled を CancellationErrorに変換すべき
//                        continuation.resume(throwing: error)
//                    } else {
//                        continuation.resume(returning: data)
//                    }
//                }
//                urlSessionTask?.resume()
//            }
//        } onCancel: {
//            urlSessionTask?.cancel() // キャンセルされた直後に実行される
//        }
//    }
//
//    func fetchOneThumbnail(withID id: String) -> UIImage? {
//        return nil
//    }
//}
