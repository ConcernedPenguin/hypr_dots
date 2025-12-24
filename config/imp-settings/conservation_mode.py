#!/usr/bin/env python3
"""
Conservation Mode Toggle for Lenovo Legion (Linux)

This script allows users to toggle battery conservation mode on Lenovo laptops
running Linux. It dynamically finds the control file and must be
run with root privileges (e.g., "sudo python3 conserve.py").

Authors: Anirudh Salgundi and Github Copilot
Contact: anirudhsalgundi@gmail.com
"""

import os
import sys
import glob  # Import glob
from pathlib import Path


class ConservationModeManager:
    """Manages battery conservation mode for Lenovo Legion laptops."""
    
    # Use a glob pattern to find the file dynamically
    PATH_PATTERN = "/sys/bus/platform/drivers/ideapad_acpi/*/conservation_mode"
    
    def __init__(self):
        """Find the control file on initialization."""
        self.mode_file = None
        self.mode_file_path_str = None
        try:
            files = glob.glob(self.PATH_PATTERN)
            if files:
                self.mode_file = Path(files[0])
                self.mode_file_path_str = files[0] # For error messages
        except Exception as e:
            print(f"!!! Error while searching for control file: {e}", file=sys.stderr)

    
    def check_system_compatibility(self):
        """Check if the system supports conservation mode."""
        if self.mode_file is None or not self.mode_file.exists():
            print("[ERROR] Conservation mode is not supported on this system.")
            print(f"        Could not find a file matching: {self.PATH_PATTERN}")
            print("        Is the 'ideapad_acpi' kernel module loaded?")
            return False
        
        # We check for write access. Since we check for root in main(),
        # this check should pass if the file exists.
        if not os.access(self.mode_file, os.W_OK):
            print("[ERROR] Cannot write to conservation mode file.")
            print(f"        Path: {self.mode_file}")
            print("        (This should not happen if script is run as root)")
            return False
            
        return True
    
    def get_current_status(self):
        """Get the current conservation mode status."""
        try:
            # We know self.mode_file exists from the compatibility check
            with open(self.mode_file, 'r') as f:
                status = f.read().strip()
                return status == '1'
        except (IOError, OSError) as e:
            print(f"!!! Error reading conservation mode status: {e}", file=sys.stderr)
            return None
    
    def set_conservation_mode(self, enable):
        """Set conservation mode on or off."""
        # This is now MUCH simpler. No os.system, no sudo, no tee.
        # We just write to the file directly, since main() already
        # confirmed we are running as root.
        value = '1' if enable else '0'
        
        try:
            with open(self.mode_file, 'w') as f:
                f.write(value)
            return True
        except (IOError, OSError) as e:
            print(f"!!! Error writing to {self.mode_file}: {e}", file=sys.stderr)
            return False
    
    def display_status(self):
        """Display current conservation mode status."""
        current_status = self.get_current_status()
        if current_status is None:
            return
        
        status_text = "ON (60% limit)" if current_status else "OFF (100% limit)"
        status_symbol = "[ON]" if current_status else "[OFF]"
        print(f"\nCurrent status: {status_symbol} Conservation mode is {status_text}")


def get_user_choice():
    """Get and validate user input."""
    while True:
        print("\n" + "="*60)
        print(">> Lenovo Legion - Battery Conservation Mode Toggle")
        print("="*60)
        print("Choose an option:")
        print("  a) Turn OFF  - Battery charges to 100% (normal mode)")
        print("  b) Turn ON   - Battery charges to 60% (conservation mode)")
        print("  s) Show current status")
        print("  q) Quit")
        print("-"*60)
        
        choice = input("Enter your choice (a/b/s/q): ").lower().strip()
        
        if choice in ['a', 'b', 's', 'q']:
            return choice
        else:
            print(f"[ERROR] Invalid input '{choice}'. Please enter 'a', 'b', 's', or 'q'.")


def main():
    """Main function to run the conservation mode manager."""
    
    # --- THIS IS THE NEW PERMISSION CHECK ---
    # Must be at the very top of main()
    if os.geteuid() != 0:
        print("[ERROR] This script modifies system files.", file=sys.stderr)
        print("        Please run it with root privileges, e.g., 'sudo python3 script.py'", file=sys.stderr)
        sys.exit(1)
    
    print(">> Battery Conservation Mode Manager for Lenovo Legion\n")
    
    manager = ConservationModeManager()
    
    # Check system compatibility
    if not manager.check_system_compatibility():
        sys.exit(1)
    
    # Show initial status
    manager.display_status()
    
    while True:
        choice = get_user_choice()
        
        if choice == 'q':
            print("\n>> Thank you for using the conservation mode manager!")
            break
        elif choice == 's':
            manager.display_status()
        elif choice == 'a':
            print("\n>> Disabling conservation mode...")
            if manager.set_conservation_mode(False):
                print("[SUCCESS] Conservation mode disabled - Battery will charge to 100%")
                manager.display_status()
        elif choice == 'b':
            print("\n>> Enabling conservation mode...")
            if manager.set_conservation_mode(True):
                print("[SUCCESS] Conservation mode enabled - Battery will charge to 60%")
                print("[NOTE] If your battery is currently above 60%, it will stay at its current level")
                print("       and won't charge further until conservation mode is disabled.")
                manager.display_status()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n>> Exiting... Thank you for using this tool!")
        sys.exit(0)
    except Exception as e:
        print(f"\n[ERROR] Unexpected error: {e}")
        print("\nIf this issue persists, please contact: anirudhsalgundi@gmail.com")
        sys.exit(1)