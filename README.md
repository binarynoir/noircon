# NoirCon

NoirCon monitors various types of addresses (e.g., IP addresses, URLs) to check their availability and sends notifications. It supports various notification methods including Pushover and native desktop notifications.

[![Support me on Buy Me a Coffee](https://img.shields.io/badge/Support%20me-Buy%20Me%20a%20Coffee-orange?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/binarynoir)
[![Support me on Ko-fi](https://img.shields.io/badge/Support%20me-Ko--fi-blue?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/binarynoir)
[![Visit my website](https://img.shields.io/badge/Website-binarynoir.tech-8c8c8c?style=for-the-badge)](https://binarynoir.tech)

## Features

- Monitors addresses to see if they are available
- Sends notifications via Pushover and native desktop notifications (macOS, Linux, Windows)
- Configurable check intervals
- Verbose logging with different log levels
- Background execution support
- Customizable configuration
- Supports multiple address monitoring
- Custom scripts on FAIL, PASS, RECOVERED, and UNKNOWN
- Detailed error reporting

## Requirements

- Bash 4.0+
- `curl` for network requests
- `powershell` for Windows desktop notifications
- `notify-send` for Linux desktop notifications

## Installation

### macOS Using Homebrew

1. Tap the repository (if not already tapped):

   ```bash
   brew tap binarynoir/noircon
   ```

2. Install NoirCon:

   ```bash
   brew install noircon
   ```

### Manual Installation (Linux/macOS Only)

1. Clone the repository:

   ```bash
   git clone https://github.com/binarynoir/noircon.git
   cd noircon
   ```

2. Make the script executable:

   ```bash
   chmod +x noircon
   ```

3. Install `notify-send` for desktop notifications (if not already installed) on Linux:

   ```bash
   # On Debian/Ubuntu-based systems
   sudo apt install libnotify-bin

   # On Fedora-based systems
   sudo dnf install libnotify

   # On Arch-based systems
   sudo pacman -S libnotify
   ```

### Windows Installation

1. Install [Git for Windows](https://gitforwindows.org/) (includes Git Bash, if not installed).

2. Clone the repository:

   ```bash
   git clone https://github.com/binarynoir/noircon.git
   cd noircon
   ```

3. Make the script executable (in Git Bash or similar terminal):

   ```bash
   chmod +x noircon
   ```

4. Ensure PowerShell is enabled in your Git Bash environment for notifications.

### Installing the Man Page (Linux/macOS Only)

1. Move the man file to the appropriate directory:

   ```bash
   sudo mv noircon.1 /usr/local/share/man/man1/
   ```

2. Update the man database:

   ```bash
   sudo mandb
   ```

3. View the man page:

   ```bash
   man noircon
   ```

## Setting Up as a Service

### Linux

1. Create a systemd service file:

   ```bash
   sudo nano /etc/systemd/system/noircon.service
   ```

2. Add the following content to the service file:

   ```ini
   [Unit]
   Description=NoirCon Service
   After=network.target

   [Service]
   ExecStart=/path/to/noircon --start
   WorkingDirectory=/path/to
   StandardOutput=syslog
   StandardError=syslog
   Restart=always
   User=your-username

   [Install]
   WantedBy=multi-user.target
   ```

   Replace `/path/to/noircon` with the actual path to the `noircon` script and `your-username` with your actual username.

3. Reload systemd to apply the new service:

   ```bash
   sudo systemctl daemon-reload
   ```

4. Enable the service to start on boot:

   ```bash
   sudo systemctl enable noircon
   ```

5. Start the service:

   ```bash
   sudo systemctl start noircon
   ```

6. Check the status of the service:

   ```bash
   sudo systemctl status noircon
   ```

### macOS

1. Create a launchd plist file:

   ```bash
   sudo nano /Library/LaunchDaemons/com.noircon.plist
   ```

2. Add the following content to the plist file:

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.noircon</string>
       <key>ProgramArguments</key>
       <array>
           <string>/path/to/noircon</string>
           <string>--start</string>
       </array>
       <key>WorkingDirectory</key>
       <string>/path/to</string>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
       <key>StandardOutPath</key>
       <string>/var/log/noircon.log</string>
       <key>StandardErrorPath</key>
       <string>/var/log/noircon.log</string>
   </dict>
   </plist>
   ```

   Replace `/path/to/noircon` with the actual path to the `noircon` script.

3. Load the plist file to start the service:

   ```bash
   sudo launchctl load /Library/LaunchDaemons/com.noircon.plist
   ```

4. Check the status of the service:

   ```bash
   sudo launchctl list | grep com.noircon
   ```

5. To unload the service:

   ```bash
   sudo launchctl unload /Library/LaunchDaemons/com.noircon.plist
   ```

### Setting Up NoirCon as a Service on Windows

1. **Create a Task in Task Scheduler**:

   - Open Task Scheduler and select "Create Task".
   - In the "General" tab, name the task "NoirCon" and select "Run whether user is logged on or not".
   - In the "Triggers" tab, click "New" and set the trigger to "At startup".
   - In the "Actions" tab, click "New" and set the action to "Start a program".
     - In the "Program/script" field, enter the path to `bash.exe` (usually located in `C:\Program Files\Git\bin\bash.exe` if using Git Bash).
     - In the "Add arguments (optional)" field, enter the path to the `noircon` script and the `--start` argument, e.g., `/path/to/noircon --start`.
   - In the "Conditions" tab, uncheck "Start the task only if the computer is on AC power" to ensure it runs on battery power as well.
   - In the "Settings" tab, ensure "Allow task to be run on demand" is checked.

2. **Save and Test the Task**:

   - Click "OK" to save the task.
   - To test the task, right-click on the "NoirCon" task in Task Scheduler and select "Run".

3. **Verify the Task**:

   - Check the status of the task in Task Scheduler to ensure it is running.
   - Verify that NoirCon is running by checking the log file or the expected notifications.

## Usage

Run the script with the desired options. Below are some examples:

- Start application with default settings:

  ```bash
  ./noircon
  ```

- Specify a custom configuration file:

  ```bash
  ./noircon --config /path/to/config
  ```

- Run the script in the background:

  ```bash
  ./noircon --start
  ```

- Send Pushover notifications:

  ```bash
  ./noircon --pushover --user-key YOUR_USER_KEY --api-token YOUR_API_TOKEN
  ```

## Configuration

NoirCon uses a configuration file to store default settings. The default location is `~/.config/noircon.json`. You can initialize a configuration file with default settings using:

```bash
./noircon --init
```

### Example Configuration File

```json
{
   "configuration": {
      "CACHE_DIR": "/tmp/noircon_cache",
      "LOG_FILE": "/tmp/noircon_cache/noircon.log",
      "CHECK_INTERVAL": "60s",
      "TIMEOUT": "5s",
      "SYSTEM_NAME": "test system",
      "PUSHOVER_NOTIFICATION": "false",
      "PUSHOVER_USER_KEY": "",
      "PUSHOVER_API_TOKEN": "",
      "DESKTOP_NOTIFICATION": "true",
      "VERBOSE": "false",
      "LOG_LEVEL": "INFO"
   },
   "connections": {
      "default": [
         {
            "NAME": "Ping Test",
            "TYPE": "PING",
            "HOST": "1.1.1.1",
            "TIMEOUT": "3s",
            "PASS_CMD": "./test/test_cmd.sh",
            "FAIL_CMD": "./test/test_cmd.sh"
         },
         {
            "NAME": "HTTP/S Test",
            "TYPE": "HTTP",
            "URL": "google.com",
            "TIMEOUT": "3s"
         },
         {
            "NAME": "TCP Test",
            "TYPE": "TCP",
            "HOST": "www.example.com",
            "PORT": "443",
            "TIMEOUT": "5s"
         },
         {
            "NAME": "UDP Test",
            "TYPE": "UDP",
            "HOST": "pool.ntp.org",
            "PORT": "123",
            "TIMEOUT": "15s"
         },
         {
            "NAME": "Domain Expiry Test",
            "TYPE": "DOMAIN",
            "DOMAIN": "google.com",
            "EXPIRY_DAYS": "200d",
            "TIMEOUT": "15s",
            "CHECK_FREQUENCY": "30d"
         },
         {
            "NAME": "Cert Expiry Test",
            "TYPE": "CERT",
            "DOMAIN": "google.com",
            "EXPIRY_DAYS": "30d",
            "TIMEOUT": "20s",
            "PASS_CMD": "./test/test_cmd.sh",
            "FAIL_CMD": "./test/test_cmd.sh",
            "RECOVERED_CMD": "./test/test_cmd.sh",
            "CHECK_FREQUENCY": "30d"
         }
      ]
   }
}
```

## Options

### General Options

- `-h, --help`: Display the help message.
- `-V, --version`: Display the script version.

### Configuration and Initialization

- `-c, --config <config_file>`: Specify a custom configuration file.
- `-i, --init`: Initialize the configuration file.
- `-f, --force-init`: Force initialize the configuration file if one exists.
- `-S, --show-config`: Show the configuration settings.
- `-e, --show-config-file`: Show the configuration file.
- `-E, --edit-config`: Edit the configuration file.

### Cache Management

- `-x, --clean`: Delete all cached files.
- `-C, --cache-dir <path>`: Specify a custom cache directory.

### Notification Options

- `-n, --system-name <name>`: Name of the system running the script.
- `-p, --pushover`: Send Pushover notifications.
- `-u, --user-key <key>`: Specify the user key for Pushover notifications.
- `-a, --api-token <token>`: Specify the API token for Pushover notifications.
- `-d, --desktop`: Send desktop notifications using AppleScript.

### Logging and Output

- `-v, --verbose`: Enable verbose output.
- `-l, --log`: Log the log file to the screen.
- `-o, --output <file>`: Specify a custom log file location.
- `-L, --log-level <level>`: Set the log level (FATAL, ERROR, WARN, INFO, DEBUG).

### Remote Connection Configuration

- `-I, --interval <s,m,h,d>`: Set the interval between checks (default: 60 seconds).
- `-T, --timeout <s,m,h,d>`: Set the connection timeout for remote connections (default: 5 seconds).
- `-N, --repeat <number>`: Repeat the checks in interactive mode N number of times and exit (default: 0).
- `-Z, --list-connections`: List the current status of all remote connections.
- `-H, --history`: Output a history of the connections to the screen.
- `-F, --force`: Ignore the check frequency and check all connections.

### Process Management

- `-s, --start`: Start the NoirCon service in the background.
- `-k, --stop`: Stop the NoirCon service.
- `-r, --restart`: Restart the NoirCon service.
- `-t, --status`: Check the current status of the NoirCon service.

## Docker Deployment Instructions

This guide provides step-by-step instructions to deploy the NoirCon service using Docker.

### Docker Prerequisites

Ensure you have the following installed on your system:

- Docker


### Using the Dockerfile

To download the `Dockerfile` from the GitHub repository, run the following command:

```sh
curl -O https://raw.githubusercontent.com/binarynoir/noircon/main/Dockerfile
```

### Build and Deploy

Navigate to the directory containing the `Dockerfile` and run the following command to build and start the service:

```sh
docker build -t noircon-image .
docker run -d --name noircon noircon-image
```

### Conclusion

You have successfully deployed the NoirCon service using Docker. The service will automatically start when the container is created and will restart if it stops unexpectedly. For any further modifications or assistance, feel free to ask!

## Instructions for Running the Tests

This document provides instructions for running the quality assurance tests for the NoirCon script using the `test.sh` file.

### Testing Prerequisites

Ensure you have the following installed on your system:

- Bash
- Git (for cloning the repository)

### Steps to Run the Tests

1. **Navigate to the Test Directory**:

   ```bash
   cd test
   ```

2. **Update the Test Configuration File**: Open the `test.json` file in your preferred text editor and ensure it contains the following configuration:

   ```json
   {
      "configuration": {
         "CACHE_DIR": "./test/cache/",
         "LOG_FILE": "./test/cache/test.log",
         "CHECK_INTERVAL": "60s",
         "TIMEOUT": "5s",
         "SYSTEM_NAME": "test system",
         "PUSHOVER_NOTIFICATION": "false",
         "PUSHOVER_USER_KEY": "",
         "PUSHOVER_API_TOKEN": "",
         "DESKTOP_NOTIFICATION": "true",
         "VERBOSE": "false",
         "LOG_LEVEL": "INFO"
      },
      "connections": {
         "default": [
            {
               "NAME": "Ping Test",
               "TYPE": "PING",
               "HOST": "1.1.1.1",
               "TIMEOUT": "3s",
               "PASS_CMD": "./test/test_cmd.sh",
               "FAIL_CMD": "./test/test_cmd.sh"
            },
            {
               "NAME": "HTTP/S Test",
               "TYPE": "HTTP",
               "URL": "google.com",
               "TIMEOUT": "3s"
            },
            {
               "NAME": "TCP Test",
               "TYPE": "TCP",
               "HOST": "www.example.com",
               "PORT": "443",
               "TIMEOUT": "5s"
            },
            {
               "NAME": "UDP Test",
               "TYPE": "UDP",
               "HOST": "pool.ntp.org",
               "PORT": "123",
               "TIMEOUT": "15s"
            },
            {
               "NAME": "Domain Expiry Test",
               "TYPE": "DOMAIN",
               "DOMAIN": "google.com",
               "EXPIRY_DAYS": "200d",
               "TIMEOUT": "15s",
               "CHECK_FREQUENCY": "30d"
            },
            {
               "NAME": "Cert Expiry Test",
               "TYPE": "CERT",
               "DOMAIN": "google.com",
               "EXPIRY_DAYS": "30d",
               "TIMEOUT": "20s",
               "PASS_CMD": "./test/test_cmd.sh",
               "FAIL_CMD": "./test/test_cmd.sh",
               "RECOVERED_CMD": "./test/test_cmd.sh",
               "CHECK_FREQUENCY": "30d"
            }
         ]
      }
   }
   ```

3. **Make the test script executable**:

   ```bash
   chmod +x test.sh
   ```

4. **Run the Test Script with Default Configuration**:

   ```bash
   ./test.sh
   ```

5. **Run the Test Script with a Custom Configuration File**:

   ```bash
   ./test.sh /path/to/custom_config_file
   ```

6. **Clean Up Test Files (optional)**:

   ```bash
   rm -rf ./test_cache
   rm -f ./test.log
   ```

### Summary

The `test.sh` script will:

1. Create a test configuration file (default or custom).
2. Run various tests to check the functionality of NoirCon, including configuration initialization, cache directory creation, log file creation, and availability monitoring.
3. Clean up the test files and directories after the tests are completed, except for the custom configuration file if it was passed in.

Follow these instructions to ensure that NoirCon is functioning correctly. If you encounter any issues, please open an issue or submit a pull request on the GitHub repository.

## Releases

### Releasing New Versions

- Update the changelog with new features and fixes.
- Commit all changed files and create a pull request.
- Run the release script from the project repo's root directory:

  ```bash
  ./scripts/publish-release.md
  ```

### Manually Releasing New Versions

- Create a new GitHub release using the new version number as the "Tag version". Use the exact version number and include a prefix `v`.
- Publish the release.

  ```bash
  git checkout main
  git pull
  git tag -a v1.y.z -m "v1.y.z"
  git push --tags
  ```

Run `shasum` on the release for homebrew distribution.

```bash
shasum -a 256 noircon-1.x.x.tar.gz
```

The release will automatically be drafted.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Author

John Smith III

## Acknowledgments

Thanks to all contributors and users for their support and feedback.
