//
//  TimerViewModel.swift
//  Toast
//
//  Created by ParkSungJoon on 06/07/2019.
//  Copyright © 2019 DDD. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TimerViewModelInputs {
    
    func pressStartTimerButton()
    func pressPlayButton()
}

protocol TimerViewModelOuputs {
    
    var pressedStartTimerButtonObserver: Observable<TimerViewController.StartButtonState> { get }
    var pressedPlayButtonObserver: Observable<TimerViewController.StartButtonState> { get }
    var startCountingObserver: Observable<String> { get }
}

protocol TimerViewModelTypes {
    
    var inputs: TimerViewModelInputs { get }
    var outputs: TimerViewModelOuputs { get }
}

class TimerViewModel: ReactiveCompatible {
    
    private var recordingController: RecordingController
    private var timerController: TimerController
    private let isStartingTimerRelay = BehaviorRelay<Bool>(value: false)
    private let isPlayingRelay = BehaviorRelay<Bool>(value: false)

    init(recordingController: RecordingController = RecordingController(),
         timerController: TimerController = TimerController()) {
        self.recordingController = recordingController
        self.timerController = timerController
    }
}

extension TimerViewModel: TimerViewModelTypes {
    
    var inputs: TimerViewModelInputs { return self }
    
    var outputs: TimerViewModelOuputs { return self }
}

extension TimerViewModel: TimerViewModelInputs {
    
    func pressStartTimerButton() {
        isStartingTimerRelay.accept(!isStartingTimerRelay.value)
    }
    
    func pressPlayButton() {
        isPlayingRelay.accept(!isPlayingRelay.value)
    }
}

extension TimerViewModel: TimerViewModelOuputs {
    
    var pressedStartTimerButtonObserver: Observable<TimerViewController.StartButtonState> {
        return isStartingTimerRelay
            .map { TimerViewController.StartButtonState(value: $0) }
            .asObservable()
    }
    
    var pressedPlayButtonObserver: Observable<TimerViewController.StartButtonState> {
        return isPlayingRelay
            .map { TimerViewController.StartButtonState(value: $0) }
            .asObservable()
    }
    
    var startCountingObserver: Observable<String> {
        return isStartingTimerRelay
            .filter { $0 == true }
            .map { [weak self] _ in
                self?.timerController.start()
            }
            .map({ [weak self] _ -> String in
                return self?.timerController.getCount() ?? ""
            })
            .asObservable()
    }
}

extension Reactive where Base: TimerViewModel {
    
    var pressStartTimerButton: Binder<Void> {
        return Binder.init(base, binding: { base, _ in
            base.pressStartTimerButton()
        })
    }
    
    var pressPlayButton: Binder<Void> {
        return Binder.init(base, binding: { base, _ in
            base.pressPlayButton()
        })
    }
}
