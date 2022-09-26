import Foundation

class AsyncSequenceProtocol {

    func onCreate() {
        let counter = Counter()
        Task {
            for await i in counter.countdown(amount: 10) {
                print(i)
            }

            let firstEven = await counter.countdown(amount: 10).first { $0 % 2 == 0 }
            print(firstEven) // 10
        }
    }
}

struct Counter {
    struct AsyncCounter: AsyncSequence {
        typealias Element = Int
        let amount: Int

        struct AsyncIterator: AsyncIteratorProtocol {
            var amount: Int

            mutating func next() async -> Element? {
                guard amount >= 0 else {
                    return nil
                }

                let result = amount
                amount -= 1
                return result
            }
        }

        func makeAsyncIterator() -> AsyncIterator {
            return AsyncIterator(amount: amount)
        }
    }

    func countdown(amount: Int) -> AsyncCounter {
        return AsyncCounter(amount: amount)
    }
}
