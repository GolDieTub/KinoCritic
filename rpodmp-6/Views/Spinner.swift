
import SwiftUI

struct Spinner: View {
    var show: Bool
    
    var body: some View {
        if show {
            ProgressView()
        } else {
            EmptyView()
        }
    }
}
