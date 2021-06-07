import SwiftUI

public struct InfiniteList<Data, Content, LoadingView>: View
where Data: RandomAccessCollection, Data.Element: Hashable, Content: View, LoadingView: View  {
  @Binding var data: Data // 1
  @Binding var isLoading: Bool // 2
    let loadingView: LoadingView
  let loadMore: () -> Void // 3
  let content: (Data.Element) -> Content // 4

  public init(data: Binding<Data>,
              isLoading: Binding<Bool>,
              loadingView: LoadingView,
              loadMore: @escaping () -> Void,
              @ViewBuilder content: @escaping (Data.Element) -> Content) { // 5
    _data = data
    _isLoading = isLoading
    self.loadingView = loadingView
    self.loadMore = loadMore
    self.content = content
  }

  public var body: some View {
    List {
       ForEach(data, id: \.self) { item in
         content(item)
           .onAppear {
              if item == data.last { // 6
                loadMore()
              }
           }
       }
       if isLoading { // 7
         loadingView
           .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
       }
    }.onAppear(perform: loadMore) // 8
  }
}
