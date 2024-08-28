//
//  WheelPicker.swift
//  RulerWheelPicker
//
//  Created by mfelipesp on 27/08/24.
//

import SwiftUI

struct WheelPicker: View {
    
    @Binding var count: Int
    
    // Range of values to be used.
    var values: ClosedRange<Int> = 0...100
    
    // Horizontal spacing between segments.
    var spacing: Double = 8.0
    
    // Number of steps between significant indicies.
    var steps: Int = 5
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: spacing) {
                        ForEach(values, id: \.self) { index in
                            let isPrimary = index % steps == .zero
                            
                            VStack(spacing: 40.0) {
                                Rectangle()
                                    .frame(
                                        width: 2.0,
                                        height: isPrimary ? 20.0 : 8.0
                                    )
                                    .frame(
                                        maxHeight: 20.0,
                                        alignment: .top
                                    )
                                Rectangle()
                                    .frame(
                                        width: 2.0,
                                        height: isPrimary ? 20.0 : 8.0
                                    )
                                    .frame(
                                        maxHeight: 20.0,
                                        alignment: .bottom
                                    )
                            }
                            .overlay {
                                if isPrimary {
                                    Text("\(index)")
                                        .font(.system(
                                            size: 24.0,
                                            design: .monospaced
                                        ))
                                        .fixedSize()
                                        .scrollTransition(axis: .horizontal, transition: { content, phase in
                                            content.opacity(phase.isIdentity ? 10.0 : 0.4)
                                        })
                                }
                            }
                            .scrollTransition { content, phase in
                                content.opacity(phase == .topLeading ? 0.2 : 1.0)
                            }
                        }
                    }
                }
                .overlay {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 2.0)
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding(.horizontal, proxy.size.width / 2)
                .scrollTargetBehavior(.snap(step: spacing  + 2.0))
                .scrollPosition(
                    id: .init(
                        get: { count },
                        set: { value, _ in
                            if let value {
                                count = value
                            }
                        }
                    )
                )
            }
        }
        .frame(width: 280.0, height: 80.0)
        .sensoryFeedback(.selection, trigger: count)
    }
}

#Preview {
    WheelPicker(count: Binding<Int>.constant(2), values: 0...100, spacing: 8, steps: 5)
}



struct SnapScrollTargetBehavior: ScrollTargetBehavior {
    
    let step: Double
    
    func updateTarget(
        _ target: inout ScrollTarget,
        context: TargetContext
    ) {
        
        let x1 = target.rect.origin.x
        let x2 = closestMultiple(a: x1, b: step)
        
        target.rect.origin.x = x2
    }
    
    private func closestMultiple(
        a: Double,
        b: Double
    ) -> Double {
        let lowerMultiple = floor((a / b)) * b
        let upperMultiple = floor(lowerMultiple + b)
        
        return if abs(a - lowerMultiple) <= abs(a - upperMultiple) {
            lowerMultiple
        } else {
            upperMultiple
        }
    }
}

extension ScrollTargetBehavior where Self == SnapScrollTargetBehavior {
    static func snap(step: Double) -> SnapScrollTargetBehavior { .init(step: step) }
}
