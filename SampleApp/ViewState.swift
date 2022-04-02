// MARK: - ViewState

enum ViewState<Content, Error> {
    case loading(content: Content?)
    case error(_ error: Error, content: Content?)
    case content(_ content: Content)
}

// MARK: - ViewState + Initialization

extension ViewState {
    init() { self = .loading(content: nil) }
}

// MARK: - ViewState + Accessor

extension ViewState {
    var content: Content? {
        switch self {
        case let .content(content),
             let .error(_, content: .some(content)),
             let .loading(content: .some(content)):
            return content
        case .error(_, content: .none), .loading(content: .none): return nil
        }
    }

    var error: Error? {
        switch self {
        case let .error(error, content: _): return error
        case .content(content: _), .loading(content: _): return nil
        }
    }

    var isLoading: Bool {
        switch self {
        case .loading(content: _): return true
        case .content(content: _), .error(_, content: _): return false
        }
    }
}

// MARK: - ViewState + Mutation

extension ViewState {
    mutating func accept(content: Content) { self = .content(content) }
    mutating func accept(error: Error) { self = .error(error, content: content) }
    mutating func startLoading() { self = .loading(content: content) }
    mutating func purge() { self = .loading(content: nil) }
}

// MARK: - ViewState + Async

extension ViewState where Error == Swift.Error {
    mutating func asyncAccept(throwingContent: () async throws -> Content) async {
        startLoading()
        do { accept(content: try await throwingContent()) } catch { accept(error: error) }
    }
}
