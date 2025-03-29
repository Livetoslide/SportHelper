//
//  SettingsView.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import SwiftUI

struct SettingsView: View {

	@State private var sets: Int = 20
	@State private var workTime: Int = 30
	@State private var restTime: Int = 25
	@State private var SkipLastRest: Bool = true;

    var body: some View {
        NavigationStack {
			VStack(spacing: 16) {
				HStack {
					Text("Подходы")
					Spacer()
					Stepper(value: $sets, in: 1...100) {
						Text("\(sets)")
					}
				}

				HStack {
					Text("Работа (сек.)")
					Spacer()
					Stepper(value: $workTime, in: 1...600) {
						Text("\(workTime)")
					}
				}

				HStack {
					Text("Отдых (сек.)")
					Spacer()
					Stepper(value: $restTime, in: 1...600) {
						Text("\(restTime)")
					}
				}

				Toggle("Пропускать последний отдых", isOn : $SkipLastRest)

				NavigationLink("Начать Тренировку") {
					let settings = WorkoutSettings(
						numbreOfSets: sets,
						workTime: workTime,
						restTime: restTime,
						skipLastRest: SkipLastRest
					)
					TimerView(settings: settings)
				}
				.padding()
				.buttonStyle(.borderedProminent)
			}
			.padding()
			.navigationTitle("Быстрая тренировка")
		}
    }
}

#Preview {
    SettingsView()
}
