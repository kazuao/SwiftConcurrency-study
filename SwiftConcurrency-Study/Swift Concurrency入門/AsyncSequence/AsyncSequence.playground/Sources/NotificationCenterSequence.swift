import UIKit

class NotificationCenterSequence {

    var enterForegroundTask: Task<Void, Never>?

    let notificationCenter = NotificationCenter.default

    // 従来の方法
    func lagacyObserve() {
        notificationCenter
            .addObserver(forName: UIApplication.willEnterForegroundNotification,
                         object: nil,
                         queue: nil) { notification in
                print("\(notification)")
            }
    }

    // Async Sequenceを使う
    func useAsyncSequence() {
        let willEnterForeground = notificationCenter.notifications(named: UIApplication.willEnterForegroundNotification)

        // キャンセルする場合は、Task型に代入
        enterForegroundTask = Task {
            for await notification in willEnterForeground {
                print(notification)
            }
        }
    }

    func cleanup() {
        enterForegroundTask?.cancel()
    }
}
