//
//  SendableSyntax.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/22.
//

import Foundation

private actor SendableSyntax {

    // Actor内で呼ぶ可能性もあるので定義するは問題ない
    func doThing(string: NSMutableString) async -> NSMutableString {
        return string
    }
}

private final class SomeClass {

    func someFunc(actor: SendableSyntax, string: NSMutableString) async {
        // Actor外でSendableではないデータを渡すとワーニングが発生する
        let result = await actor.doThing(string: string)
        print(result)
    }
}


// MARK: - Sendable準拠
// MARK: すべてがSendableに準拠
struct SendableOK: Sendable {
    var title: String
    var message: String
}

// MARK: Sendableに準拠していないものがある
struct SendableNG: Sendable {
    var title: String
    var message: NSString
    /* stored property 'message' of 'Sendable'-conforming struct 'SendableNG' has non-sendable type 'NSString */
}

// MARK: 型パラメータ<T>がSendableに準拠されているか保証されていない
struct GenericsType<T>: Sendable {
    var a: T
    /* stored property 'a' of 'Sendable'-conforming generic struct 'GenericsType' has non-sendable type 'T' */
}

// MARK: where句で型パラメータが準拠が保証されている
struct ConfirmSendable<T> {
    var a: T
}
// extensionで定義する場合は同じファイルからwhereで指定する必要がある
extension ConfirmSendable: Sendable where T: Sendable {}

// こうでもいい
struct ConfirmSendable2<T: Sendable> {
    var a: T
}

// MARK: - 準拠の基準（enum, struct）
/*
 1. publicではなく、@usableFromInlineでもないstructとenumに対してはSendableに準拠できるかチェックが通れば準拠とみなす
 2. publicなstructとenumでも@frozenであれば、Sendableに準拠できるかチェックし、チェクが通れば準拠とみなす
 3. ジェネリック型の場合は方引数がSendableに樹居していることが保証されていれば、準拠とみなす
 */
// MARK: 1
// publicでないなら暗黙的に準拠
struct Person {
    var name: String
    var age: Int
}

// publicなので、暗黙的に準拠しない
public struct Person2 {
    var name: String
}

// MARK: 2
// publicでも@frozenなので暗黙的に準拠
@frozen public struct Person3 {
    var name: String
}

// MARK: 3
// ItemがSendableなのでBoxも暗黙的にSendable
struct Box<Item: Sendable> {
    var item: Item
}

// MARK: Itemに指定はないのでBox2は暗黙的にSendableしない
struct Box2<Item> {
    var item: Item
}

// 明示的にSendableに準拠させることは可能
extension Box2: Sendable where Item: Sendable {}

// MARK: - 準拠の基準（class）
// finalかつ不変のストアドプロパティのみで構成されていること
final class MyClass: Sendable {
    let name: String
    init(name: String) {
        self.name = name
    }
}

// コンパイルにチェックさせない場合は@uncheckedを付与する
// Sendableか保証してくれないので、自分で確認する
class MyClass2: @unchecked Sendable {}

// MARK: - @Sendable
// 関数に付与することで、関数もSendableにすることができる
@Sendable
func someFunc(_ name: String) -> String {
    return name
}

// closureにも付与できる
let closure: (@Sendable (String) -> Void) = { _ in }

/*
 1. キャプチャされるデータはSendableプロトコルに準拠が必要（↓はString）
 2. 可変なローカル変数をキャプチャできない（var）
 */
func nestedFunc() {
    var state: Int = 42

    // ↓エラーになる
    let closure: (@Sendable (Int) -> Void) = { new in
        print(state)
    }
    closure(1)

    class NestA {
        var nsString: NSString = "apple"
    }

    let nest = NestA() // letなのでキャプチャできる

    @Sendable
    func updateLocalState(number: Int) {
        state += number // error
        nest.nsString = "banana" // warning
    }
}
