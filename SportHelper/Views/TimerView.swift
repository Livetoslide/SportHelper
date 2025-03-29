import SwiftUI

struct TimerView: View {
	@StateObject private var viewModel: TimerViewModel
	@Environment(\.dismiss) private var dismiss

	init(settings: WorkoutSettings) {
		_viewModel = StateObject(wrappedValue: TimerViewModel(settings: settings))
	}

	var body: some View {

		ZStack {

			// Фон меняется в зависимости от состояния:
			// Подготовка – синий, работа – зеленый, отдых – красный.
			if viewModel.isPreparing {
				Color.blue.ignoresSafeArea()
			} else {
				(viewModel.isRest ? Color.red : Color.green)
					.ignoresSafeArea()
			}

			VStack(spacing: 20) {
				Text(viewModel.isPreparing ? "Подготовка" : (viewModel.isRest ? "Отдых" : "Работа"))
					.font(.title)

				Text(viewModel.formatedTime())
					.font(.system(size: 48, weight: .bold))

				// Отображаем номер подхода только если не подготовка
				if !viewModel.isPreparing {
					Text("Подход \(viewModel.currentSet) из \(viewModel.settings.numbreOfSets)")
						.font(.subheadline)
				}
				HStack(spacing: 40) {
					Button(action: {
						if viewModel.isTimerRunning {
							viewModel.stopTimer()
						} else {
							viewModel.startTimer()
						}
					}) {
						Text(viewModel.isTimerRunning ? "Пауза" : "Продолжить")
					}
					.buttonStyle(.borderedProminent)

					Button(action: {
						viewModel.stopTimer()
						dismiss()
					}) {
						Text("Завершить")
					}
					.buttonStyle(.borderedProminent)
				}
			}
			.padding()
		}
		.onAppear {
			viewModel.startTimer()
		}
		.onDisappear {
			viewModel.stopTimer()
		}
		.navigationTitle("Таймер")
	}
}

