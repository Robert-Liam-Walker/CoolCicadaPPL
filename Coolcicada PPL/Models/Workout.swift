//
//  Workout.swift
//  Coolcicada PPL
//
//  Created by Liam Walker on 5/31/24.
//

import Foundation

struct Workout : Identifiable {
    let id = UUID()
    let name: String
    var exercises: [Exercise]
    let date: Date
}
