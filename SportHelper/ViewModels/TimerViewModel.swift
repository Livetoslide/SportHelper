//
//  TimreViewModel.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import Foundation
import UIKit
import Combine

class TimerViewModel: ObservableObject {
	@Published var currentTime: Int = 0
	@Published var currentSet: Int = 1
	@Published var isRest: Bool = false
	@Published var isTimerRunning: Bool = false

	let settings: WorkoutSettings
	var timer: AnyCancellable?

	init(settings: WorkoutSettings) {
		self.settings = settings
		self.currentTime = settings.workTime
	}

	func startTimer() {
		stopTimer()
		isTimerRunning = true
		timer = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in
				self?.tick()
			}
	}

	func stopTimer() {
		timer?.cancel()
		timer = nil
		isTimerRunning = false
	}

	private func tick() {
		guard currentTime > 0 else {
			timerDidFinish()
			return
		}
		currentTime -= 1
	}

	private func timerDidFinish() {
		stopTimer()

		if isRest {
			currentSet += 1

			if currentSet > settings.numbreOfSets {
				//тренировка окончена
				return
			}
			isRest = false
			currentTime = settings.workTime
		} else {
			//конец рабочей фазы
			//проверка на пропуск последнего отдыха
			if currentSet == settings.numbreOfSets, settings.skipLastRest {
				//тренировка закончена
				return
			}
			isRest = true
			currentTime = settings.restTime
		}

		//запуск след фазы
		startTimer()
	}

	func formatedTime() -> String {
		let minutes = currentTime / 60
		let seconds = currentTime % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}

}
	
	
