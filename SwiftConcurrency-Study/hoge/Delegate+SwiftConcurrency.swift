//
//  Delegate+SwiftConcurrency.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/05/11.
//

import Foundation

/*
 - CheckedContinuationをメンバ変数に保持し、delegateメソッド側でresumeする
 - 必ず１回しか呼ばれないDelegateの場合しか使えない
    - CheckedContinuationのresumeを2回以上呼ぶと、runtime errorになる
 */

protocol TimerDelegate {
    func waitTimer() async -> String
    func timeUp(_ message: String)
}

class TimerManager {
    var delegate: TimerDelegate?
    func startTimer() {}
}

class Delegate_SwiftConcurrency: TimerDelegate {

    private let timerManager = TimerManager()
    private var activeContinuation: CheckedContinuation<String, Never>?

    init() {
        timerManager.delegate = self
    }

    func waitTimer() async -> String {
        await withCheckedContinuation({ continuation in
            activeContinuation = continuation
            timerManager.startTimer()
        })
    }

    func timeUp(_ message: String) {
        activeContinuation?.resume(returning: message)
        activeContinuation = nil
    }
}
