//
//  TimerText.swift
//  Track_habbits
//
//  Created by Егор Ерохин on 16/05/2026.
//

import SwiftUI

struct TimerText: View {
    
    let selectedPreset: WallpaperPreset
    
    let timeString: String

    var body: some View {

        Text(timeString)
            .font(.system(size: 60))
            .fontWeight(Font.Weight.bold)
            .foregroundStyle(selectedPreset.textColor)
            .fontDesign(Font.Design.rounded)
        
    }
}
