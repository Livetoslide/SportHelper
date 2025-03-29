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
	@Published var isPreparing: Bool = true
	@Published var isTimerRunning: Bool = false

	let settings: WorkoutSettings
	var timer: AnyCancellable?

	init(settings: WorkoutSettings) {
		self.settings = settings
		self.currentTime = settings.prepareTime
		self.isPreparing = true
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
		   // Останавливаем таймер, чтобы обновить состояние
		   stopTimer()

		   if isPreparing {
			   // Фаза подготовки закончилась – начинаем работу
			   isPreparing = false
			   currentTime = settings.workTime
		   } else if !isRest {
			   // Если сейчас была фаза работы – переключаемся на отдых
			   // Если это последний подход и опция пропуска последнего отдыха включена, тренировка завершается
			   if currentSet == settings.numbreOfSets && settings.skipLastRest {
				   return
			   }
			   isRest = true
			   currentTime = settings.restTime
		   } else {
			   // Фаза отдыха закончилась – переходим к следующему подходу
			   currentSet += 1
			   if currentSet > settings.numbreOfSets {
				   // Тренировка завершена
				   return
			   }
			   isRest = false
			   currentTime = settings.workTime
		   }

		   // Запускаем таймер для новой фазы
		   startTimer()
	   }

	func formatedTime() -> String {
		let minutes = currentTime / 60
		let seconds = currentTime % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}

}
	
	
