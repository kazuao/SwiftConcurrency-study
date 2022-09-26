//
//  ActorMainThread.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/22.
//

import SwiftUI

//@main
//struct MyApp: App {
//    @StateObject var model = Model()
//    @StateObject var mainActorModel = MainActorModel()
//    @StateObject var mainActorSubModel = MainActorSubModel()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView(
//                model: model,
//                mainActorModel: mainActorModel,
//                mainActorSubModel: mainActorSubModel
//            )
//        }
//    }
//}
//
//struct ContentView: View {
//    @ObservedObject var model: Model
//    @ObservedObject var mainActorModel: MainActorModel
//    @ObservedObject var mainActorSubModel: MainActorSubModel
//
//    var body: some View {
//        VStack {
//            Text("Hello, world!")
//        }
//        .task {
//            await model.foo()
//            await model.bar()
//            await model.baz()
//
//            await mainActorModel.foo()
//            await mainActorModel.bar()
//            await mainActorModel.baz()
//            await mainActorModel.hoge()
//
//            await mainActorSubModel.foo()
//            await mainActorSubModel.bar()
//            await mainActorSubModel.piyo()
//        }
//    }
//}
//
//class Model: ObservableObject {
//    func foo() async {
//        assert(Thread.isMainThread, "単にメインスレッドから呼び出されりゃメインスレッド")
//
//        Task {
//            assert(!Thread.isMainThread, "Taskはワーカースレッド。おそらく引き継ぐActorがないから?")
//            print("model\(#function)")
//        }
//    }
//
//    func bar() async {
//        assert(Thread.isMainThread, "単にメインスレッドから呼び出されりゃメインスレッド")
//
//        Task { @MainActor in
//            assert(Thread.isMainThread, "TaskはMainActor指定されているのでメインスレッド")
//            print("model.\(#function)")
//
//            Task.detached(priority: .utility) {
//                assert(!Thread.isMainThread, "Task.detachedされてワーカースレッド")
//            }
//        }
//    }
//
//    @MyActor
//    func baz() async {
//        assert(!Thread.isMainThread, "メソッドがSubActor指定されてるのでワーカースレッド")
//
//        Task {
//            assert(!Thread.isMainThread, "TaskはメソッドがSubActor指定されてるのでワーカースレッド")
//            print("model.\(#function)")
//
//            Task { @MainActor in
//                // Task.detached { @MainActor in ... } のほうが明確な気がしないでもない。
//                // 結局MainActorに切り替えてるんだから。
//                // そもそもDispatchQueue.main.async みたいなあんまりこういうレガシーなことやりたくない。最後の手段。
//                assert(Thread.isMainThread, "TaskはMainActor指定されているのでメインスレッド")
//            }
//        }
//    }
//}
//
//@MainActor
//class MainActorModel: ObservableObject {
//    func foo() async {
//        assert(Thread.isMainThread, "MainActorだしメインスレッド")
//
//        Task {
//            assert(Thread.isMainThread, "Taskは暗黙的に所属Actorに従うのでメインスレッド")
//            print("mainActorModel.\(#function)")
//
//            Task.detached(priority: .utility) {
//                assert(!Thread.isMainThread, "Task.detachedされてワーカースレッド")
//            }
//        }
//    }
//
//    @MyActor
//    func bar() async {
//        Task {
//            // つまり 型のActor < メソッドの指定Actor ってコト？
//            assert(!Thread.isMainThread, "TaskはSubActor指定されてるのでワーカースレッド")
//            print("mainActorModel.\(#function)")
//        }
//    }
//
//    @MyActor
//    func baz() async {
//        Task { @MainActor in
//            // つまり 型のActor < メソッドの指定Actor < Taskの指定Actor ってコト？
//            assert(Thread.isMainThread, "TaskはMainActor指定されてるのでメインスレッド")
//            print("mainActorModel.\(#function)")
//        }
//    }
//
//    nonisolated func hoge() async {
//        assert(Thread.isMainThread, "実行スレッドになるだけなのでメインスレッド")
//        Task {
//            assert(!Thread.isMainThread, "ワーカースレッド。nonisolatedされてるのでMainActorを引き継がない")
//        }
//    }
//}
//
//class MainActorSubModel: MainActorModel {
//    override func foo() async {
//        assert(Thread.isMainThread, "継承元がMainActorだしメインスレッド")
//        print("mainActorSubModel.\(#function)")
//    }
//
//    override func bar() async {
//        assert(!Thread.isMainThread, "override元のメソッドに従ってワーカースレッド")
//        print("mainActorSubModel.\(#function)")
//    }
//
//    func piyo() async {
//        Task {
//            assert(Thread.isMainThread, "Taskは暗黙的に所属Actorに従うのでメインスレッド")
//            print("mainActorSubModel.\(#function)")
//        }
//    }
//}
//
//@globalActor
//struct MyActor {
//    actor Sample { }
//    static var shared = Sample()
//}
