//
//  Exercise.swift
//  Coolcicada PPL
//
//  Created by Liam Walker on 5/31/24.
//

import Foundation

struct Exercise : Identifiable{
    let id = UUID()
    let name: String
    let sets: Int
    let reps: String
    var weight : Int
}
