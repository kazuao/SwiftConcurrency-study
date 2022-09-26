import Foundation

@MainActor
class UserDataSource {
    // 暗黙的にMainActorが適応されている
    var user: String = ""
    func updateUser() {}

    // nonisolatedでMainActorを解除する
    nonisolated func sendLogs() {}
}

// MARK: MainActorでUIデータ更新
@MainActor
final class ViewModel: ObservableObject {
    @Published var text: String = ""

    // サーバ通信はメインスレッドで実行すべきではないので、nonisolatedをつける
//    nonisolated func fetchUser() async {
//        // エラーが発生する
//        // nonisolatedではプロパティが更新できない
//        text = await waitOneSecond(with: "arex")
//    }

    nonisolated func fetchUser() async -> String {
        return await waitOneSecond(with: "Arex")
    }

    func didTapButton() {
        Task {
            text = ""
//            await fetchUser()
            // ↑これを↓こう
            text = await fetchUser()
        }
    }

    private func waitOneSecond(with string: String) async -> String {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
        return string
    }
}
