//
//  LRUImageCache.swift
//  CineStream
//
//  Created by Akash Ingawale on 25/05/25.
//

import Foundation
import SwiftUI
import Combine

class LRUImageCache<Key: Hashable, Value> {

    private class Node {
        let key: Key
        var value: Value
        var next: Node?
        var prev: Node?

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }

    // MARK: Properties

    private let capacity: Int
    private var head: Node?
    private var tail: Node?
    private var cache: [Key: Node] = [:]
    private let lock = NSLock()

    // MARK: Inits

    init(capacity: Int) {
        self.capacity = max(1, capacity)
    }

    // MARK: Public methods

    func get(_ key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }

        guard let node = cache[key] else {
            return nil
        }

        moveToHead(node)
        return node.value
    }

    func set(_ key: Key, value: Value) {
        lock.lock()
        defer { lock.unlock() }

        if let node = cache[key] {
            node.value = value
            moveToHead(node)
        } else {
            let newNode = Node(key: key, value: value)

            if cache.count == capacity {
                removeTail()
            }

            cache[key] = newNode
            addToHead(newNode)
        }
    }

    func removeAll() {
        lock.lock()
        defer { lock.unlock() }

        cache.removeAll()
        head = nil
        tail = nil
    }

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return cache.count
    }

    // MARK: - Private Methods

    private func moveToHead(_ node: Node) {
        removeNode(node)
        addToHead(node)
    }

    private func removeNode(_ node: Node) {
        let prev = node.prev
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }

        if let next = next {
            next.prev = prev
        } else {
            tail = prev
        }

        node.prev = nil
        node.next = nil
    }

    private func addToHead(_ node: Node) {
        node.next = head
        node.prev = nil

        head?.prev = node
        head = node

        if tail == nil {
            tail = node
        }
    }

    private func removeTail() {
        guard let tail = tail else { return }
        removeNode(tail)
        cache.removeValue(forKey: tail.key)
    }
}
