# Sustainable Building Modeler (SBM) Lua API Definitions for Visual Studio Code ✨

This repository provides a generated Lua API definition file (`sbm_api_definitions.lua`) designed to enhance your Lua scripting experience for **Sustainable Building Modeler (SBM)** within Visual Studio Code.

By integrating this file with the **sumneko.lua Language Server** extension, you will gain intelligent autocompletion, hover documentation, and improved syntax checking for SBM's custom Lua API.

---

## 📑 Table of Contents

- [1. Introduction](#1-introduction)
- [2. Prerequisites](#2-prerequisites)
- [3. Setting Up Visual Studio Code 🛠️](#3-setting-up-visual-studio-code-️)
  - [Install Visual Studio Code](#install-visual-studio-code)
  - [Install the sumneko.lua Extension](#install-the-sumnekolua-extension)
  - [Configure VS Code to Use the API Definitions](#configure-vs-code-to-use-the-api-definitions)
- [4. Using the API Definitions 💡](#4-using-the-api-definitions-)
- [5. Troubleshooting 🐛](#5-troubleshooting-)
- [6. Contributing 🤝](#6-contributing-)

---

## 1. Introduction

When writing Lua scripts for **Sustainable Building Modeler (SBM)**, having proper code completion and documentation is crucial for efficiency and accuracy. SBM exposes its functionalities to Lua via a custom API.

This project provides a method to generate a `.lua` definition file that, when used with the **sumneko.lua** Visual Studio Code extension, enables:

- **Autocompletion (IntelliSense)**: Suggestions for SBM's functions, parameters, and return types as you type.
- **Hover Documentation**: Detailed descriptions of functions and their usage when you hover over them.
- **Parameter Hints**: Information about function parameters while you're typing a function call.
- **Improved Syntax Checking**: Better identification of potential issues related to SBM's API.

---

## 2. Prerequisites

Before you begin, ensure you have the following:

- **Sustainable Building Modeler (SBM)** – The application itself.
- **Visual Studio Code** – A free, open-source code editor. [Download VS Code](https://code.visualstudio.com)
- **sumneko.lua Extension** – The Lua language server for VS Code. (Search "Lua" in the Extensions Marketplace.)

---

## 3. Setting Up Visual Studio Code 🛠️

### Install Visual Studio Code

If you haven't already, download and install VS Code from the [official website](https://code.visualstudio.com).

### Install the sumneko.lua Extension

1. Open Visual Studio Code.
2. Go to the **Extensions** view:
   - Click the Extensions icon (four squares) on the left sidebar, or
   - Press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (macOS).
3. Search for **Lua**.
4. Install the one by **sumneko** (usually the most popular one).

### Configure VS Code to Use the API Definitions

Once you have the `sbm_api_definitions.lua` file and the sumneko.lua extension installed:

1. Open VS Code **Settings**:

   - `File > Preferences > Settings` (Windows/Linux)
   - `Code > Settings > Settings` (macOS)
   - Or use `Ctrl+,` (Windows/Linux) or `Cmd+,` (macOS)

2. Search for: `Lua.workspace.library`

3. **Add the Path**:

   - Click "Add Item" under **Lua > Workspace: Library**
   - Provide the **absolute path** to the folder containing `sbm_api_definitions.lua`

#### Examples

- **Windows**: `C:\MySBM_API_Defs`
- **macOS/Linux**: `/Users/YourUser/Documents/MySBM_API_Defs`

#### 🔁 Alternative (Recommended for Git Projects)

Copy `sbm_api_definitions.lua` to your project's `.vscode` folder or a subfolder like `sbm-api-definitions`, then create or update `.vscode/settings.json`:

```json
{
  "Lua.workspace.library": [
    "${workspaceFolder}/sbm-api-definitions"
    // or if placed directly in .vscode:
    // "${workspaceFolder}/.vscode"
  ]
}
```

This approach ensures the configuration is portable with the project on GitHub.

---

## 4. Using the API Definitions 💡

Once setup is complete, open any `.lua` file in your project using SBM’s API. You should now see:

- **Autocompletion** for SBM functions (e.g., `SBM_Application.loadModel`)
- **Hover Documentation** with function details
- **Parameter Hints** as you type arguments

---

## 5. Troubleshooting 🐛

### No Autocompletion?

- Ensure the **sumneko.lua** extension is installed and enabled.
- Verify that `Lua.workspace.library` is set **correctly and absolutely**.
- **Restart VS Code** after making configuration changes.
- Ensure `sbm_api_definitions.lua` exists and contains valid definitions.

### Outdated Definitions?

If SBM updates its API, make sure you update your `sbm_api_definitions.lua` file to match the latest version. VS Code should pick up changes automatically.

---

## 6. Contributing 🤝

Found an issue or want to improve this project?

- Open an [issue](https://github.com/your-repo/issues)
- Submit a pull request (PR)

Your contributions are welcome and appreciated!

---

📁 *Happy coding with SBM Lua scripts!*

