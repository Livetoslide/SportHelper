//
//  CardToggleRaw.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import SwiftUI

struct CardToggleRow: View {
	let title: String
	@Binding var isOn: Bool

	var body: some View {
		HStack {
			Text(title)
				.font(.caption)
				.foregroundColor(.secondary)
			Spacer()
			Toggle("", isOn: $isOn)
				.labelsHidden()
		}
		.padding()
		.frame(maxWidth: .infinity)
		.background(Color(uiColor: .systemGray6))
		.cornerRadius(12)
	}
}

