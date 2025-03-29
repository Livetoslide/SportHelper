//
//  WorkoutSettings.swift
//  SportHelper
//
//  Created by Александр Зимарев on 29.03.2025.
//

import Foundation

struct WorkoutSettings {
	var numbreOfSets: Int
	var workTime: Int
	var restTime: Int
	var skipLastRest: Bool = false
	var prepareTime: Int = 5
}
