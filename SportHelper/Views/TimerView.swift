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
			let baseColor = viewModel.isPreparing ? Color.blue :
			(viewModel.isRest ? Color.red : Color.green)
			baseColor
				.brightness(-0.2)
				.ignoresSafeArea()

			// Второй слой
			GeometryReader { geometry in

				let fullHeight = UIScreen.main.bounds.height

				let totalSeconds = currentPhaseTotalSeconds()
				// Сколько времени прошло в текущей фазе
				let elapsed = totalSeconds - viewModel.currentTime
				// Доля прогресса
				let progressRatio = CGFloat(elapsed) / CGFloat(totalSeconds)

				VStack(spacing: 0) {
					Spacer(minLength: 0)

					Rectangle()
						.fill(baseColor).brightness(-0.15)
						.frame(height: fullHeight * progressRatio)
						.animation(.linear(duration: 0.1), value: progressRatio)
				}
				.ignoresSafeArea()
			}

			if viewModel.workoutFinished {
				FinishView()
					.transition(.opacity)

			} else {
				VStack(spacing: 20) {

					Spacer()

					Text(viewModel.isPreparing ? "ПОДГОТОВКА" : (viewModel.isRest ? "ОТДЫХ \(viewModel.currentSet) / \(viewModel.settings.numbreOfSets)" : "РАБОТА \(viewModel.currentSet) / \(viewModel.settings.numbreOfSets)"))
						.font(.title)
						.colorInvert()

					Text(viewModel.formatedTime())
						.font(.system(size: 98, weight: .bold))
						.colorInvert()

					Spacer()

					TimerControlsView(
						isTimerRunning: $viewModel.isTimerRunning,
						onPauseResumeTap: {
							if viewModel.isTimerRunning {
								viewModel.stopTimer()
							} else {
								viewModel.startTimer()
							}
						},
						onBackTap: {
							viewModel.goToPreviousPhase()
						},
						onForwardTap: {
							viewModel.goToNextPhase()
						}
					)
				}
				.padding()
			}
		}
		.onAppear {
			viewModel.startTimer()
		}
		.onDisappear {
			viewModel.stopTimer()
		}
		.navigationTitle("Таймер")
	}
		

	private func currentPhaseTotalSeconds() -> Double {
		if viewModel.isPreparing {
			return Double(viewModel.settings.prepareTime)
		} else if viewModel.isRest {
			return Double(viewModel.settings.restTime)
		} else {
			return Double(viewModel.settings.workTime)
		}
	}
}



