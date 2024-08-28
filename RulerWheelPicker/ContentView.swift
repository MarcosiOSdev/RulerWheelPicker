//
//  ContentView.swift
//  RulerWheelPicker
//
//  Created by mfelipesp on 27/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var count: Int = 5
    
    var body: some View {
        VStack {
            
            Text("Count : \(count)")
            
            WheelPicker(count: $count, values: 0...20, spacing: 8, steps: 3)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
