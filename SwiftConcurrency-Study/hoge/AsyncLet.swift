//
//  AsyncLet.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/27.
//

import Foundation
import UIKit

//class Asynclet {
//
//    func fetchOneThumbnail(withID id: String) async throws -> UIImage {
//        let imageReq = imageRequest(for: id), metadataReq = metadataRequest(for: id)
//
//        async let (data, _) = URLSession.shared.data(for: imageReq)
//        async let (metadata, _) = URLSession.shared.data(for: metadataReq)
//
//        guard let size = parseSize(from: try await metadata),
//              let image = try await UIImage(data: data)?.byPreparingThumbnail(ofSize: size) else {
//            throw ThumbnailFailedError()
//        }
//
//        return image
//    }
//
//    func imageRequest(for id: String) {
//        
//    }
//
//    func metadataRequest(for id: String) {
//
//    }
//
//    func parseSize(from data: Data) {
//
//    }
//}
//
//extension UIImage {
//    func byPreparingThumbnail(ofSize: Double) -> UIImage {
//        return self
//    }
//}

struct ThumbnailFailedError: Error {

}
