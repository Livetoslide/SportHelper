//
//  FireworksView.swift
//  SportHelper
//
//  Created by Александр Зимарев on 05.04.2025.
//

import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation

struct FinishView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var synthesizer = AVSpeechSynthesizer()

	var body: some View {
		ZStack {
			Color.green.brightness(-0.2).ignoresSafeArea()
			Text("Отличная работа")
				.font(.title)
				.colorInvert()
		}
		.onAppear {
			let utterance = AVSpeechUtterance(string: "Отличная работа")
			utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
			synthesizer.speak(utterance)

			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				dismiss()
			}
		}
	}
}



