# SwiftConcurrency-study

## 参考
- https://zenn.dev/hirothings/scraps/5e1100ca5b4b99
- https://zenn.dev/akkyie/articles/swift-concurrency
- https://zenn.dev/akkyie/articles/swift-concurrency
 
## 用語
・async/await: 構文
・Structured Concurrency: 並行処理の関係性を整理するための概念
 ・Actor: 安全な並行処理を記述するための型
 
## Async/Await
・await後の処理は、await前と同じスレッドとは限らない
・initializerにもasyncをつけられる
・withCheckedContinuationのresumeは1回のみ必ず呼ぶ
 
## AsyncSequence
- 必ずひとつのタスクから一つのAsyncStreamを呼び出す

	
## Runloop.mainとDispatchQueue.mainの違い
・Runloopはユーザインタラクション中は、ビジー状態になり、待機する
・DispatchQueueは即時実行

・ユーザインタラクション中にDispatchQueueで更新をすると、わずかに数フレーム影響する可能性がある

・RunLoopのほうが良さげ
・Taskないであれば、MainActor.run {}も使えそう


## Sendable
- Sendableプロトコルは、指定されたタイプの値を並行コードで安全に使用できることを示すもの
- 並列処理などでデータ競合が起きる可能性がある場合、Sendableプロトコルに適合していないものを弾くことができる。@Sendable
- 適合するには、structやenumの値型、classの場合は普遍のletである必要がある。
- MakerProtocolであるため、コンパイル時のチェックでのみ動作する。
    - isやasを使用した動的判定には用いることができない

- struct, enum
    - associated typeなどがすべてsendableに準拠している必要がある
    
- @preconcurrecy
    - ライブラリやObjective-Cコードなどに対し、コンパイルチェックを行わないようにできる
    - enum, enum case, struct, class, actor, protocol, var, let, subscript, init, funcに付与dケイル
     

## Actor
・Actorはアクセスされる際、データを他の部分からIsolateする
・actorの処理は、ほかから実行された場合、一つの処理が終わるまで他の処理が行われない
・継承できない
・actorの変数は、外から書き込むことができない


## Task
- Structured Concurrency
    - スレッド実行に制御フローを導入し、カプセル化することで、プログラムがexitする前に生成されたスレッド処理を必ず完了させるもの
- タスクツリー
    - タスクを階層化したもの
    - 一番下の階層のタスクが完了したら、上位のタスクが実行される
    - 陽会のタスクにエラーが発生すると、上位のタスクにエラーが伝播され、キャンセルされる
- タスクグループ
- Task.init 
    - Taskは変数でスコープ外に持つことができるため、Unstructured Concurrencyと呼ばれる
    - 上位階層の優先度やActor、タスクローカル値を引き継ぐ
- Task.detached
    - なにも引き継がない
    
## 既存のコードにSwift Concurrencyを導入
- wrapper関数を作成する
- もとの呼び出し関数には、`@available(iOS, deprecated: 13.0, message: "")`を付与し、warningを発生させる


## memo
 ・Task.detached(priority: .background)
	・非同期かつ、同じスレッドで実行する必要がない場合
	・親のコンテキストを引き継がない
	・withTaskGroup
	→非同期かつ並列処理が行える
	
