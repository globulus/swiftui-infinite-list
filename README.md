# SwiftUIInfiniteList

Infinite scrolling list in SwiftUI:

* A single view, that can be used just like any other List.
* Renders data from a collection via a ViewBuilder and triggers loading when the list is scrolled to the bottom.
* Customizable loading view (spinner).
* Built-in [pull-to-refresh functionality](https://github.com/globulus/swiftui-pull-to-refresh).

![in action](https://swiftuirecipes.com/user/pages/01.blog/infinite-scroll-list-in-swiftui/ezgif-7-f83ec7550e4e.gif)

### Recipe

Check out [this recipe](https://swiftuirecipes.com/blog/infinite-scroll-list-in-swiftui) for in-depth description of the component and its code. Check out [SwiftUIRecipes.com](https://swiftuirecipes.com) for more **SwiftUI recipes**!

### Sample usage

```swift
struct InifiniteListTest: View {
    @ObservedObject var viewModel: ListViewModel
    
    var body: some View {
        InfiniteList(data: $viewModel.items,
                     isLoading: $viewModel.isLoading,
                     loadingView: ProgressView(),
                     loadMore: viewModel.loadMore,
                     onRefresh: viewModel.refresh(refreshComplete:)) { item in
            Text(item.text)
        }
    }
}

struct ListItem: Hashable {
    let text: String
}

class ListViewModel: ObservableObject {
    @Published var items = [ListItem]()
    @Published var isLoading = false
    private var page = 1
    private var subscriptions = Set<AnyCancellable>()
    
    func loadMore() {
        guard !isLoading else { return }
        
        isLoading = true
        (1...15).publisher
            .map { index in ListItem(text: "Page: \(page) item: \(index)") }
            .collect()
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [self] completion in
                isLoading = false
                page += 1
            } receiveValue: { [self] value in
                items += value
            }
            .store(in: &subscriptions)
    }
    
    func refresh(refreshComplete: RefreshComplete) {
        subscriptions.forEach { $0.cancel() }
        items.removeAll()
        isLoading = false
        page = 1
        loadMore()
        refreshComplete()
    }
}
```

### Installation

This component is distrubuted as a **Swift package**. 
