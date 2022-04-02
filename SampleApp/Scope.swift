import Foundation

// MARK: - Scope

protocol Scope {}

extension Scope {
    @inlinable
    @inline(__always)
    func `let`<Tranformed>(_ block: (Self) throws -> Tranformed) rethrows -> Tranformed { try block(self) }

    @inlinable
    @inline(__always)
    func `let`<Tranformed>(_ block: (Self) async throws -> Tranformed) async rethrows -> Tranformed { try await block(self) }
}

extension Scope where Self: AnyObject {
    @inlinable
    @inline(__always)
    func apply(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }

    @inlinable
    @inline(__always)
    func apply(_ block: (Self) async throws -> Void) async rethrows -> Self {
        try await block(self)
        return self
    }
}

// MARK: - Functional

protocol Functional: Scope {}

extension Functional {
    func takeIf(_ block: (Self) -> Bool) -> Self? { block(self) ? self : nil }
    func takeIfNot(_ block: (Self) -> Bool) -> Self? { !block(self) ? self : nil }
}

// MARK: - Optional + Scope

extension Optional: Scope {}

// MARK: - Int + Functional

extension Int: Functional {}

// MARK: - Int64 + Functional

extension Int64: Functional {}

// MARK: - Double + Functional

extension Double: Functional {}

// MARK: - String + Functional

extension String: Functional {}

// MARK: - Array + Functional

extension Array: Functional {}

// MARK: - Dictionary + Functional

extension Dictionary: Functional {}

// MARK: - Result + Functional

extension Result: Functional {}

// MARK: - NSObject + Functional

extension NSObject: Functional {}

// MARK: - Set + Functional

extension Set: Functional {}
