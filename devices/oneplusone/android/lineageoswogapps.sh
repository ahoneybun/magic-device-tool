clear
echo ""
echo "Installing LineageOS 14.1 without Gapps"
echo ""
sleep 1
echo "Please boot your Oneplus One into bootloader/fastboot mode by pressing Power & Volume Up (+)"
echo ""
sleep 1
echo -n "Is your Oneplus One in bootloader/fastboot mode now? [Y] "; read bootloadermode
if [ "$bootloadermode"==Y -o "$bootloadermode"==y -o "$bootloadermode"=="" ]; then
  clear
  echo ""
  echo "Detecting device"
  echo ""
  sleep 1
  fastboot devices > /tmp/AttachedDevices
fi
if grep 'device$\|fastboot$' /tmp/AttachedDevices
then
  echo "Device detected !"
  sleep 1
  clear
  fastboot format cache
  fastboot format userdata
  fastboot reboot-bootloader
  sleep 6
  clear
  echo ""
  echo "Downloading TWRP recovery"
  echo ""
  wget -c --quiet --show-progress --tries=10 http://people.ubuntu.com/~marius.quabeck/magic-device-tool/recoverys/twrp-3.0.2-0-bacon.img
  sleep 1
  echo ""
  echo "Downloading LineageOS 14.1.."
  echo ""
  sleep 1
  wget -c --quiet --show-progress --tries=10 https://mirrorbits.lineageos.org/full/bacon/20170123/lineage-14.1-20170123-nightly-bacon-signed.zip
  clear
  echo ""
  echo "Installing TWRP recovery"
  echo ""
  fastboot flash recovery twrp-3.0.2-0-bacon.img
  sleep 1
  echo ""
  echo "Rebooting device.."
  echo ""
  echo "This will take ~35 seconds. Don't disconnect your device!"
  echo ""
  fastboot reboot-bootloader
  sleep 7
  fastboot boot twrp-3.0.2-0-bacon.img
  sleep 20
  adb reboot recovery
  sleep 20
  echo ""
  clear
  echo ""
  echo "Pushing zip's to device"
  sleep 1
  echo ""
  echo "Please wait this can take a while"
  echo ""
  echo "You may see a prompt asking you for read/write permissions"
  echo "Ignore that prompt, the tool will take care of the installation"
  echo ""
  echo "  → LineageOS 14.1 zip "
  adb push -p lineage-14.1-20170123-nightly-bacon-signed.zip /sdcard/
  echo ""
  sleep 1
  echo ""
  echo "Installing LineageOS.."
  echo ""
  adb shell twrp install /sdcard/lineage-14.1-20170123-nightly-bacon-signed.zip
  sleep 1
  echo ""
  echo "Wipe cache.."
  echo ""
  adb shell twrp wipe cache
  adb shell twrp wipe dalvik
  echo ""
  adb reboot
  echo "The device is now rebooting. Give it time to flash the new ROM. It will boot on its own."
  echo ""
  sleep 5
  echo ""
  echo "Cleaning up.."
  rm -f /tmp/AttachedDevices
  echo ""
  sleep 1
  echo "Exiting script. Bye Bye"
  sleep 1

else
  echo "Device not found"
  rm -f /tmp/AttachedDevices
  sleep 1
  echo ""
  echo "Back to menu"
  sleep 1
  . ./launcher.sh
fi