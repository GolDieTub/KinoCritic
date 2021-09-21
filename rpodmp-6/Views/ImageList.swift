import SwiftUI

struct ImageList: View {
    @State private var offset: CGFloat = 0
    @State private var index: Int
    private var images: [Image]
    
    init(current: Int, images: [Image]) {
        self.images = images
        
        _index = State(initialValue: current)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 0) {
                    ForEach(0..<images.count, id: \.self) { i in
                        VStack {
                            Spacer()
                            
                            images[i]
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width)
                            
                            Spacer()
                        }
                    }
                }
            }
            .content.offset(x: self.offset)
            .onAppear { offset = -geometry.size.width * CGFloat(index) }
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ self.offset = $0.translation.width - geometry.size.width * CGFloat(self.index) })
                    .onEnded({ value in
                        if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.images.count - 1 {
                            self.index += 1
                        }
                        
                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                            self.index -= 1
                        }
                        
                        withAnimation { self.offset = -(geometry.size.width + 0) * CGFloat(self.index) }
                    })
            )
        }
    }
    
}
