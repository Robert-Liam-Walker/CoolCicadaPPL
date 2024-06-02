//
//  Coolcicada_PPLApp.swift
//  Coolcicada PPL
//
//  Created by Liam Walker on 5/31/24.
//

import SwiftUI

@main
struct Coolcicada_PPLApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: WorkoutViewModel())
        }
    }
}
