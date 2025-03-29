//
//  CardRaw.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import SwiftUI

/// Карточка вида:
///  [ - ]  [  ПОДХОДЫ   ]
///         [    20     ]
///  [ + ]
struct CardRow: View {
	let title: String
	let value: String
	let onMinus: () -> Void
	let onPlus: () -> Void

	var body: some View {
		HStack(spacing: 16) {
			Button(action: onMinus) {
				Image(systemName: "minus.circle.fill")
					.font(.system(size: 32))
			}

			Spacer()

			VStack(spacing: 4) {
				Text(title)
					.font(.caption)
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)

				Text(value)
					.font(.title2)
					.bold()
			}

			Spacer()

			Button(action: onPlus) {
				Image(systemName: "plus.circle.fill")
					.font(.system(size: 32))
			}
		}
		.padding()
		.frame(maxWidth: .infinity)       // Растягиваем по ширине
		.background(Color(uiColor: .systemGray6))  // Или .thinMaterial
		.cornerRadius(12)
	}
}


