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
	@Published var currentTime: Double
	@Published var currentSet: Int = 1
	@Published var isRest: Bool = false
	@Published var isPreparing: Bool = true
	@Published var isTimerRunning: Bool = false

	let settings: WorkoutSettings
	var timer: AnyCancellable?

	private let synthesizer = AVSpeechSynthesizer()

	init(settings: WorkoutSettings) {
		self.settings = settings
		self.currentTime = Double(settings.prepareTime)
		self.isPreparing = true
	}

	func startTimer() {
		stopTimer()
		isTimerRunning = true
		timer = Timer.publish(every: 0.1 , on: .main, in: .common)
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
		if currentTime > 0.1 {
			currentTime -= 0.1
			// Если мы в подготовке и осталось менее 5 секунд, озвучиваем целые секунды при переходе границы
			if isPreparing {
				let remaining = Int(ceil(currentTime))
				if remaining <= 5 && Double(remaining) - currentTime < 0.1 {
					speak(number: remaining)
				}
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
			   currentTime = Double(settings.workTime)
		   } else if !isRest {
			   speak(text: "Отдых")
			   // Если сейчас была фаза работы – переключаемся на отдых
			   // Если это последний подход и опция пропуска последнего отдыха включена, тренировка завершается
			   if currentSet == settings.numbreOfSets && settings.skipLastRest {
				   return
			   }
			   isRest = true
			   currentTime = Double(settings.restTime)
		   } else {
			   // Фаза отдыха закончилась – переходим к следующему подходу
			   speak(text: "Начали")
			   currentSet += 1
			   if currentSet > settings.numbreOfSets {
				   // Тренировка завершена
				   return
			   }
			   isRest = false
			   currentTime = Double(settings.workTime)
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

	// Переход к следующему этапу по кнопке "Вперёд"
	func goToNextPhase() {
		stopTimer()
		if isPreparing {
			// Из подготовки сразу переходим в работу первого подхода
			speak(text: "Начали")
			isPreparing = false
			currentTime = Double(settings.workTime)
		} else if !isRest {
			// Если в рабочей фазе, то переход в отдых, если он предусмотрен
			if currentSet == settings.numbreOfSets && settings.skipLastRest {
				// Если это последний подход и отдых пропускается, оставляем работу
				// Можно не менять фазу или завершать тренировку
				return
			} else {
				speak(text: "Отдых")
				isRest = true
				currentTime = Double(settings.restTime)
			}
		} else {
			// Если в фазе отдыха, переходим к работе следующего подхода
			speak(text: "Начали")
			currentSet += 1
			if currentSet > settings.numbreOfSets {
				return
			}
			isRest = false
			currentTime = Double(settings.workTime)
		}
		startTimer()
	}

	// Переход к предыдущему этапу по кнопке "Назад"
	func goToPreviousPhase() {
		stopTimer()
		if isPreparing {
			// Если в подготовке, ничего не делаем (нет предыдущей фазы)
			// Или можно оставить подготовку без изменений
			return
		} else if !isRest {
			// Если в рабочей фазе
			if currentSet == 1 {
				// Если это первая рабочая фаза, предыдущий этап – подготовка
				isPreparing = true
				currentTime = Double(settings.prepareTime)
				speak(text: "Подготовка")
			} else {
				// Если не первая рабочая фаза, предыдущий этап – отдых предыдущего подхода
				currentSet -= 1
				isRest = true
				currentTime = Double(settings.restTime)
				speak(text: "Отдых")
			}
		} else {
			// Если в отдыхе, предыдущий этап – работа той же фазы (без изменения номера подхода)
			isRest = false
			currentTime = Double(settings.workTime)
			speak(text: "Начали")
		}
		startTimer()
	}

	func formatedTime() -> String {
		let total = Int(ceil(currentTime))
		let minutes = total / 60
		let seconds = total % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}

}
	
	
