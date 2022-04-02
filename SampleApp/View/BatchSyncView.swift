import SwiftUI
import PointSDK

struct BatchSyncView: View {
    @State private var isExpanded = false
    
    let type: HealthQueryType
    let syncResult: BatchSyncResult
    var body: some View {
        Section {
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Uploaded samples: \(syncResult.successSampleCount)")
                    Text("Failed samples: \(syncResult.remainingSampleCount)")
                }
            }
        } header: {
            Button {
                isExpanded.toggle()
            } label: {
                Text(type.rawValue)
            }
        }
    }
}

