# Spark Wallet

## Dependencies

Spark requires Core Lightning to be installed and running on the Embassy in order to function.

## Usage Instructions

### Browser

1. Navigate to your Spark Server URL (.onion) from any Tor-enabled browser.
1. Insert your username and password, located in `Properties`. These values can be changed in `Config`.

### Linux, MacOS and Windows

1. Download the native Spark Wallet application for your platform (not yet available for iOS).
1. Retrieve your Spark *Server URL* and *Access Key* from `Properties` and enter it into the Server Settings dialog in Spark Wallet.  This can be automated by clicking the QR Code icon next to *Pairing URL* from `Properties`, then hitting *Scan QR* in Spark Wallet's Server Settings.

### Android

1. Repeat the `Linux, MacOS and Windows` steps above, but before step 2, make sure Orbot is installed, with [*VPN Mode* enabled](https://start9.com/latest/user-manual/connecting/connecting-tor/tor-os/tor-android#orbot-vpn-mode), and that Spark Wallet is among Orbot's VPN Mode *Tor-Enabled Apps*.

For more detailed instructions on how to use Spark Wallet and the Lightning Network, see the official Spark [documentation](https://github.com/shesek/spark-wallet).
