//
//  TimerViewController.swift
//  Toast
//
//  Created by ParkSungJoon on 06/07/2019.
//  Copyright © 2019 DDD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CountdownLabel

class TimerViewController: BaseViewController {
    
    @IBOutlet private var secondsButtons: [UIButton]!
    @IBOutlet private weak var recordingStartButton: UIButton!
    @IBOutlet private weak var recordingResetButton: UIButton!
    @IBOutlet private weak var recordingPlayButton: UIButton!
    @IBOutlet private weak var timerLabel: CountdownLabel!
    
    private let recordingController = RecordingController()
    private let timerViewModel = TimerViewModel()
    
    private let disposeBag = DisposeBag()
    
    enum StartButtonState {
        case start
        case stop
        
        init(value: Bool) {
            switch value {
            case true:
                self = .start
            default:
                self = .stop
            }
        }
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        secondsButtons.forEach {
            $0.rx.tap
                .bind(to: rx.setupSecondsButton)
                .disposed(by: disposeBag)
        }
        
        recordingPlayButton.rx.tap
            .bind(to: timerViewModel.rx.pressPlayButton)
            .disposed(by: disposeBag)
        
        
        recordingStartButton.rx.tap
            .bind(to: timerViewModel.rx.pressStartTimerButton)
            .disposed(by: disposeBag)
        
        timerViewModel.outputs.pressedStartTimerButtonObserver
            .bind(to: rx.setupRecordingStartButton)
            .disposed(by: disposeBag)
        
        timerViewModel.outputs.pressedPlayButtonObserver
            .bind(to: rx.setupRecordingPlayButton)
            .disposed(by: disposeBag)
        
        timerViewModel.outputs.startCountingObserver
            .subscribe { (value) in
                print(value)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Private
private extension TimerViewController {
    
    func setupSecondsButton() {
        print("asd")
    }
    
    func setupRecordingStartButton(by state: StartButtonState) {
        let buttonImage = (StartButtonState.start == state ?  #imageLiteral(resourceName: "stopBtn") : #imageLiteral(resourceName: "startBtn"))
        recordingStartButton.setImage(buttonImage, for: .normal)
    }
    
    func setupRecordingPlayButton(by state: StartButtonState) {
        let buttonImage = (StartButtonState.start == state ? #imageLiteral(resourceName: "recordStopBtn") : #imageLiteral(resourceName: "recordPlayBtn"))
        recordingPlayButton.setImage(buttonImage, for: .normal)
    }
    
    func pressStartButton() {
        timerLabel.setCountDownTime(minutes: 30)
        timerLabel.animationType = .Evaporate
        timerLabel.start()
    }
    
    func pressStopButton() {
        timerLabel.pause()
    }
}

// MARK: - Reactive
extension Reactive where Base: TimerViewController {
    
    var setupRecordingStartButton: Binder<Base.StartButtonState> {
        return Binder.init(base, binding: { base, state  in
            base.setupRecordingStartButton(by: state)
            base.pressStartButton()
        })
    }
    
    var setupRecordingPlayButton: Binder<Base.StartButtonState> {
        return Binder.init(base, binding: { base, state in
            base.setupRecordingPlayButton(by: state)
            base.pressStopButton()
        })
    }
    
    var setupSecondsButton: Binder<Void> {
        return Binder.init(base, binding: { base, _ in
            base.setupSecondsButton()
        })
    }
}
