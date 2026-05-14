# QumuloAlerts Changelog

## 7.2.2
- Bug Fix: Publisher plugins failed to reconnect to the cluster after a network outage or cluster reboot — all plugins now attempt reconnection before retrying
- Bug Fix: SMB shares with user-variable paths (e.g. `/home/%U`) caused directory aggregate lookups to fail
- Bug Fix: Login page credentials were sent as a GET request instead of POST
- Enhancement: Audit plugin now monitors syslog connection status and generates alerts when the connection is established or lost
- Enhancement: Email server port field in the Web UI is now a dropdown with standard SMTP ports (25, 587, 465)

## 7.2.1
- New: Web UI introduced for managing QumuloAlerts configuration
