// Hardware device service UUIDs and characteristics
// These match the firmware implementation for audio streaming and device management

// Main audio service UUID
const String hardwareAudioServiceUuid = '19b10000-e8f2-537e-4f6c-d104768a1214';

// Audio characteristics
const String hardwareAudioDataCharacteristicUuid = '19b10001-e8f2-537e-4f6c-d104768a1214';

// Button service UUID (used in scanning)
const String hardwareButtonServiceUuid = '23ba7924-0000-1000-7450-346eac492e92';

// Battery service UUID (standard BLE service)
const String hardwareBatteryServiceUuid = '0000180f-0000-1000-8000-00805f9b34fb';
const String hardwareBatteryLevelCharacteristicUuid = '00002a19-0000-1000-8000-00805f9b34fb';

// Device information service UUID (standard BLE service)
const String hardwareDeviceInfoServiceUuid = '0000180a-0000-1000-8000-00805f9b34fb';
const String hardwareModelNumberCharacteristicUuid = '00002a24-0000-1000-8000-00805f9b34fb';
const String hardwareFirmwareRevisionCharacteristicUuid = '00002a26-0000-1000-8000-00805f9b34fb';
const String hardwareHardwareRevisionCharacteristicUuid = '00002a27-0000-1000-8000-00805f9b34fb';
const String hardwareManufacturerNameCharacteristicUuid = '00002a29-0000-1000-8000-00805f9b34fb';

// Audio configuration constants
const int hardwareDefaultMtu = 512;
const int hardwareSampleRate = 16000;
const int hardwareBitDepth = 16;
const int hardwareChannels = 1;
