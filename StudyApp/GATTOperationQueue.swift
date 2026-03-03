//
//  GATTOperationQueue.swift
//  StudyApp
//
//  Created by Rajesh Mani on 22/01/26.
//
import Foundation
import CoreBluetooth

final class GATTOperationQueue {
    private var queue: [() -> Void] = []
    private var isExecuting = false

    func enqueue(_ operation: @escaping () -> Void) {
        queue.append(operation)
        executeNext()
    }

    func complete() {
        isExecuting = false
        executeNext()
    }

    private func executeNext() {
        guard !isExecuting, !queue.isEmpty else { return }
        isExecuting = true
        queue.removeFirst()()
    }
}
enum BLEDeviceState {
    case disconnected
    case connecting
    case discoveringServices
    case ready
    case failed(Error)
}

@MainActor
final class BLEDevice {

    let peripheral: CBPeripheral
    private(set) var state: BLEDeviceState = .disconnected

    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.peripheral.delegate = nil
    }

    func updateState(_ newState: BLEDeviceState) {
        state = newState
    }

    func write(
        _ data: Data,
        to characteristic: CBCharacteristic
    ) async throws {
        // Note: You must resume the continuation in the CBPeripheralDelegate callback when the write completes.
        // Example: continuation.resume() or continuation.resume(throwing: error)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            // continuation resumed in delegate callback
        }
    }
}

@MainActor
final class BLECentralManager {

    private var devices: [UUID: BLEDevice] = [:]

    // BLEDevice is main-actor isolated for thread safety.
    func register(_ peripheral: CBPeripheral) {
        devices[peripheral.identifier] = BLEDevice(peripheral: peripheral)
    }

    func device(for id: UUID) -> BLEDevice? {
        devices[id]
    }
}

