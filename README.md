# Hosted Link

- Access the project on the web at: https://jesscsang.github.io/friendlyreminder.github.io/
- Proceed to `Step 8` of the project setup guide.

# Setup Project Locally (Windows)

### 1. Install and Install Flutter

- Download and install flutter from https://docs.flutter.dev/get-started/install

### 2. Add FLutter to `PATH`

- Locate the `flutter/bin` directory and it to the `PATH` environment variable.

### 3. Open Command Prompt

- Open a command prompt window and navigate to the project directory.

### 4. Install Project Dependencies

- Run the following command to install project dependencies

```bash
flutter pub get
```

### 5. Set Up sqflite for Web

- Run the following command to to install the `sqlite3.wasm binaries` needed to create a local sqflite database for web.

```bash
dart run sqflite_common_ffi_web:setup
```

### 6. Run the Project

- Start the project by running the following command.

```bash
flutter run
```

### 7. Open Flutter Project as Web App

- You will be prompted to connect a device. Choose a web browser from the list of available devices.

**Example**

```bash
$ flutter run
Connected devices:
Windows (desktop) • windows • windows-x64    • Microsoft Windows [Version
10.0.19045.5131]
Chrome (web)      • chrome  • web-javascript • Google Chrome 131.0.6778.109
Edge (web)        • edge    • web-javascript • Microsoft Edge 131.0.2903.70
[1]: Windows (windows)
[2]: Chrome (chrome)
[3]: Edge (edge)
Please choose one (or "q" to quit):
```

### 8. Open Developer Tools

- Once the app is running, right-click anywhere on the page and select `Inspect` to open Developer Tools

### 9. Toggle Device Emulation

- In the Developer Tools pane, look for the device toolbar icon (a small phone/tablet icon) located at the top left corner of the Developer Tools window.

### 10. Select iPhone 12 Pro

- In the device toolbar, you will see a dropdown menu labeled **Dimensions Responsive**. Click on this dropdown and choose iPhone 12 Pro from the list of different devices.
