import SwiftUI

struct WorkoutRecommendationsView: View {
    @ObservedObject var viewModel: WorkoutRecommendationViewModel

    private var notAvailable: String {
        "Not Available"
    }

    var body: some View {
        List {
            StateView(state: viewModel.state) { recommendations in
                ForEach(recommendations, id: \.id) { recommendation in
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ID: \(recommendation.id)")
                        Text("Date: \(recommendation.date ?? notAvailable)")
                        Text("Activity ID: \(unwrapOrNotAvailable(recommendation.activityId))")
                        Text("Activity Name: \(recommendation.activityName ?? notAvailable)")
                        Text("Saved at: \(recommendation.savedAt ?? notAvailable)")
                        Text("Workout ID: \(unwrapOrNotAvailable(recommendation.workoutId))")
                        Text("Completed at: \(recommendation.completedAt ?? notAvailable)")
                        Text("Created at: \(recommendation.createdAt ?? notAvailable)")
                        Text("Updated at: \(recommendation.updatedAt ?? notAvailable)")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AsyncButton(action: { await viewModel.getWorkoutRecommendations(date: .now) }) {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
        .navigationTitle("Recommendations")
        .task { await viewModel.getWorkoutRecommendations(date: .now) }
    }
    
    private func unwrapOrNotAvailable(_ int: Int?) -> String {
        if let int = int { return "\(int)" }
        return notAvailable
    }
}
