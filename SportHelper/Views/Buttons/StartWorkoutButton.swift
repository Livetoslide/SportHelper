//
//  StartWorkoutButton.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import SwiftUI

struct StartWorkoutButton: View {
	let totalTime: Int

	var body: some View {
		HStack {
			Image(systemName: "play.fill")
			Text("Начать тренировку")
			Spacer()
			Text(timeString(from: totalTime))
		}
		.font(.headline)
		.foregroundColor(.white)
		.padding()
		.frame(maxWidth: .infinity)
		.background(Color.black)
		.cornerRadius(12)
	}
}

