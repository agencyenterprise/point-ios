import PointSDK
import SwiftUI

struct HealthMetricView: View {
    let healthMetric: HealthMetric
    var body: some View {
        Text("Date: \(healthMetric.date)")
        if let value = healthMetric.value.takeIfNot(\.isEmpty) { Text("Value: \(value)") }
        if let variance = healthMetric.variance { Text("Variance: \(variance)") }
        if let workoutId = healthMetric.workoutId { Text("Workout ID: \(workoutId)") }
    }
}
