//
//  TimerControlsView.swift
//  SportHelper
//
//  Created by Александр Зимарев on 05.04.2025.
//

import SwiftUI

struct PressDownButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.97 : 1.0)  // чуть уменьшаем масштаб
			.offset(y: configuration.isPressed ? 2 : 0)           // сдвигаем вниз на 2 пункта при нажатии
			.animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
	}
}


struct TimerControlsView: View {
	@Binding var isTimerRunning: Bool
	var onPauseResumeTap: () -> Void

	var body: some View {
		HStack {
			Spacer()
			Button(action: onPauseResumeTap) {
				HStack(spacing: 8) {
					Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
					// Оборачиваем текст в ZStack с невидимым "Продолжить" для фиксированной ширины
					ZStack {
						Text(isTimerRunning ? "Пауза" : "Продолжить")
						Text("Продолжить")
							.opacity(0)
					}
				}
				.font(.title3.bold())
				.foregroundColor(.white)
				.padding(.horizontal, 30)
				.padding(.vertical, 14)
				.background(Color.black.opacity(0.7))
				.cornerRadius(12)
			}
			.buttonStyle(PressDownButtonStyle())
			Spacer()
		}
		.padding()
	}
}



