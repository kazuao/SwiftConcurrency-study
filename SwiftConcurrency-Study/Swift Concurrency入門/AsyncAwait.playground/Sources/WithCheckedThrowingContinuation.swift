import Foundation

fileprivate class WithCheckedThrowingContinuation {
    func request(with urlString: String, completion: @escaping (Result<String, Error>) -> Void) {}

    func newAsyncRequest(with urlString: String) async throws -> String {
        return try await withCheckedThrowingContinuation({ continuation in
            request(with: urlString) { result in
                continuation.resume(with: result)
            }

            /*
             continuation.resume(returning:) // 正常系
             continuation.resume(throwing:)  // エラー
             continuation.resume(with:)      // Result型を渡す
             */
        })
    }

    func task() {
        Task.detached {
            let urlString = "https://api.github.com/search/repositories?q=swift"
            let result = try await self.newAsyncRequest(with: urlString)
            print(result)
        }
    }
}
