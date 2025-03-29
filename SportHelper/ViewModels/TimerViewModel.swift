//
//  TimreViewModel.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import Foundation
import UIKit
import Combine
import AVFoundation

class TimerViewModel: ObservableObject {
	@Published var currentTime: Int = 0
	@Published var currentSet: Int = 1
	@Published var isRest: Bool = false
	@Published var isPreparing: Bool = true
	@Published var isTimerRunning: Bool = false

	let settings: WorkoutSettings
	var timer: AnyCancellable?

	private let synthesizer = AVSpeechSynthesizer()

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
		if currentTime > 1 {
			currentTime -= 1
			// Во время подготовки, если осталось 5-1 секунда, озвучиваем обратный отсчет
			if currentTime <= 5 {
				speak(number: currentTime)
			}
		} else {
			timerDidFinish()
		}
	}

	private func timerDidFinish() {
		   // Останавливаем таймер, чтобы обновить состояние
		   stopTimer()

		   if isPreparing {
			   // Фаза подготовки закончилась – начинаем работу
			   speak(text: "Начали")
			   isPreparing = false
			   currentTime = settings.workTime
		   } else if !isRest {
			   speak(text: "Отдых")
			   // Если сейчас была фаза работы – переключаемся на отдых
			   // Если это последний подход и опция пропуска последнего отдыха включена, тренировка завершается
			   if currentSet == settings.numbreOfSets && settings.skipLastRest {
				   return
			   }
			   isRest = true
			   currentTime = settings.restTime
		   } else {
			   // Фаза отдыха закончилась – переходим к следующему подходу
			   speak(text: "Начали")
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

	private func speak(number: Int) {
		let utterance = AVSpeechUtterance(string: "\(number)")
		utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
		synthesizer.speak(utterance)

		// Виброотклик для числового обратного отсчёта (легкий удар)
		//let impactGenerator = UIImpactFeedbackGenerator(style: .light)
		//impactGenerator.prepare()
		//impactGenerator.impactOccurred()
	}

	private func speak(text: String) {
		let utterance = AVSpeechUtterance(string: text)
		utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
		synthesizer.speak(utterance)

		//vibrateForPhrase(text: text)
	}

	//
	private func vibrateForPhrase(text: String) {
		let generator = UINotificationFeedbackGenerator()
		generator.prepare()
		if text == "Начали" {
			generator.notificationOccurred(.success)
		} else if text == "Отдых" {
			generator.notificationOccurred(.warning)
		} else {
			generator.notificationOccurred(.error)
		}
	}

	func formatedTime() -> String {
		let minutes = currentTime / 60
		let seconds = currentTime % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}

}
	
	
