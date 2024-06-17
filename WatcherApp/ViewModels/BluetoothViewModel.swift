//
//  BluetoothViewModel.swift
//  WatcherApp
//
//  Created by macbook on 24.12.2023.
//

import Foundation
import CoreBluetooth

class BluetoothViewModel: NSObject, CBCentralManagerDelegate, ObservableObject {
    
    var centralManager: CBCentralManager!
    var peripheralDevice: CBPeripheral!
    
    let watchName = "CircleWatch_743926"
    let SERVICE_UUID = CBUUID(string: "8a1b5b74-15a8-44f2-9175-01fd0c08702d")
    let CHARACTERISTIC_UUID = CBUUID(string: "42e2c66a-bff1-409e-9b99-1c7c5ad05970")
    
    // TEST UUIDs
    //let watchName = "CircleWatch_accc25"
    //let watchName = "TeestWatch"
    //let SERVICE_UUID = CBUUID(string: "5679c1ce-d128-49a4-b66d-b117bdbc6514")
    //let CHARACTERISTIC_UUID = CBUUID(string: "c3df6acf-7bac-47cb-9303-d1060adbd357")
    
    @Published var watchConnected: Bool = false
    @Published var tryingToConnect: Bool = true
    var timer: Timer?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if !watchConnected && central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning..........")
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] timer in
                if let isConnected = (self?.watchConnected) {
                    if !isConnected {
                        self?.tryingToConnect = false
                    }
                    self?.centralManager.stopScan()
                }
            }
            
        } else {
            print("Bluetooth not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let deviceName = peripheral.name {
            if deviceName == watchName {
                self.peripheralDevice = peripheral
                self.peripheralDevice.delegate = self
                central.connect(self.peripheralDevice, options: nil)
                print("Connecting to CircleWatch ...")
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheralDevice.discoverServices([SERVICE_UUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let curError = error {
            print("Error on disconnecting: \(curError.localizedDescription)")
        }
        watchConnected = false
    }
    
    func sendText(_ text: String) {
        guard let peripheralDevice = peripheralDevice,
              let characteristic = peripheralDevice.services?.first?.characteristics?.first(where: { $0.uuid == CHARACTERISTIC_UUID })
        else {
            print("Peripheral or characteristic not found")
            return
        }
        
        print("Sending: \(text)")
        let data = text.data(using: .utf8)!
        peripheralDevice.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
}

extension BluetoothViewModel: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let curError = error {
            print("Error didDiscoverServices: \(curError.localizedDescription)")
        }
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == CHARACTERISTIC_UUID {
                watchConnected = true
                self.centralManager.stopScan()
                print("Found characteristic!")
                peripheral.readValue(for: characteristic)

            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let inputData = characteristic.value else { return }
        let converted = String(decoding: inputData, as: UTF8.self)
        print("Got input data in peripheral: \(converted)")
    }
}


