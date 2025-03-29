//
//  SettingsView.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import SwiftUI

func timeString(from totalSeconds: Int) -> String {
	let minutes = totalSeconds / 60
	let seconds = totalSeconds % 60
	return String(format: "%02d:%02d", minutes, seconds)
}

func calculateTotalTime(settings: WorkoutSettings) -> Int {
	// Общее время работы
	let totalWork = settings.numbreOfSets * settings.workTime

	let totalRest = settings.skipLastRest
		? (settings.numbreOfSets - 1) * settings.restTime
		: settings.numbreOfSets * settings.restTime

	//Gодготовка + работа + отдых
	return settings.prepareTime + totalWork + totalRest
}


struct SettingsView: View {

	@State private var sets: Int = 20
	@State private var workTime: Int = 30
	@State private var restTime: Int = 25
	@State private var SkipLastRest: Bool = true
	@State private var prepareTime: Int = 5

    var body: some View {
        NavigationStack {
			VStack(spacing: 16) {
				// Заголовок экрана
				Text("Быстрая тренировка")
					.font(.title)
					.bold()
					.padding(.top)
				// Если нужна "Подготовка" в том же стиле
				CardRow(
				     title: "ПОДГОТОВКА (сек.)",
				     value: timeString(from: prepareTime),
				     onMinus: { prepareTime = max(1, prepareTime - 5) },
				     onPlus: { prepareTime += 5 }
				 )

				// Карточка: Подходы
				CardRow(
					title: "ПОДХОДЫ",
					value: "\(sets)",
					onMinus: {
						sets = max(1, sets - 1)
					},
					onPlus: {
						sets += 1
					}
				)

				// Карточка: Работа
				CardRow(
					title: "РАБОТА (сек.)",
					value: timeString(from: workTime),
					onMinus: {
						// шаг 5 секунд, или 1 — как тебе удобнее
						workTime = max(1, workTime - 5)
					},
					onPlus: {
						workTime += 5
					}
				)

				// Карточка: Отдых
				CardRow(
					title: "ОТДЫХ (сек.)",
					value: timeString(from: restTime),
					onMinus: {
						restTime = max(1, restTime - 5)
					},
					onPlus: {
						restTime += 5
					}
				)

				// 4) Переключатель
				CardToggleRow(title: "Пропускать последний отдых", isOn: $SkipLastRest)

				Spacer()


				let settings = WorkoutSettings(
					numbreOfSets: sets,
					workTime: workTime,
					restTime: restTime,
					skipLastRest: SkipLastRest,
					prepareTime: prepareTime
				)

				NavigationLink(
					destination: TimerView(settings: settings)
				) {
					StartWorkoutButton(
						totalTime: calculateTotalTime(settings: settings)
					)
				}
				.padding(.bottom, 8)

			}
			.padding()
		}
    }
}

#Preview {
    SettingsView()
}
