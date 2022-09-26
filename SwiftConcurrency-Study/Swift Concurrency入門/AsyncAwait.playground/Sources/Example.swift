import SwiftUI

fileprivate class Example {

    var isLoading = true

    func downloadImage(data: Data) async throws -> UIImage {
        return UIImage(systemName: "star")!
    }

    func resizeImage(image: UIImage) async throws -> UIImage {
        return image
    }

    //func request(url: URL, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
    //
    //    let task = URLSession.shared.dataTask(with: url) { data, response, error in
    //        guard error == nil else { return }
    //
    //        downloadImage(data: data) { result in
    //            let image = try? result.get()
    //
    //            resizeImage(image: image) { result in
    //                completionHandler(result)
    //            }
    //        }
    //    }
    //
    //    task.resume()
    //}

    func request(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)

        let image = try await downloadImage(data: data)
        let resizedImage = try await resizeImage(image: image)
        return resizedImage
    }

    func onCreate() {
        Task.detached {
            do {
                let url = URL(string: "https://api.github.com/search/repositories?q=swift")!
                let response = try await self.request(url: url)

                self.isLoading = false
                print(response)
            } catch {
                self.isLoading = false
                print("Error: ", error.localizedDescription)
            }
        }

        /* それぞれが待機する */
        Task.detached {
            //    let result = await b()
            //    let d = await D(label: result)

            // ↓このように書ける
            //    let d = await D(label: b())

            //    print(d)
        }
    }
}
