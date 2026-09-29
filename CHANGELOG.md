# QumuloAlerts Changelog

## 7.2.5
- Fix: Alerts container crashed on startup due to an incompatibility between fastapi-pagination
- Fix: Email address fields on quota, default quota, and soft quota alerts were limited to 255 characters (VARCHAR), columns expanded to TEXT with a migration for existing deployments
- Update: Grafana updated to 11.2.10-security-01

## 7.2.4
- Fix: Removed `PRIVILEGE_SNAPSHOT_CALCULATE_USED_CAPACITY_READ` as a required cluster privilege — this privilege no longer exists in newer Qumulo Core releases, causing cluster verification to fail on upgrade
- Enhancement: Improved internal release versioning to support greater flexibility in how QumuloAlerts and Qumulo Core versions are aligned
- Fix: Email address fields on quota, default quota, and soft quota alerts were limited to 255 characters (VARCHAR), causing an Internal Server Error when more than ~10 addresses were configured via the Web UI; columns expanded to TEXT with a migration for existing deployments

## 7.2.3
- Bug Fix: Collector failed to reconnect to the cluster after a connection loss due to an uninitialized reconnect delay counter
- Bug Fix: RabbitMQ queues were declared as transient non-durable, causing connection failures on RabbitMQ 4.x
- Bug Fix: Monitoring plugin crashed when a previously offline node rejoined the cluster
- Bug Fix: Disk error alerts fired spuriously on Collector startup for drives with pre-existing cumulative error counters
- Bug Fix: Email consumer crashed in an infinite reconnect loop when a message arrived with an unknown translation key (e.g. `audit-connect-error`) — consumer plugin now catches missing translation keys and logs an error instead of propagating the exception into the RabbitMQ channel
- Bug Fix: Metrics consumer crashed in an infinite reconnect loop when the VPN plugin sent a malformed OpenMetrics message — the VPN metrics label set was never closed and had no value or timestamp, causing a parse failure in the Metrics consumer; both the malformed output and the unguarded parse call are now fixed
- Fix: Added database migration file to insert missing `audit-connected` and `audit-connect-error` translation keys for all 20 supported locales into existing deployments

## 7.2.2
- Bug Fix: Publisher plugins failed to reconnect to the cluster after a network outage or cluster reboot — all plugins now attempt reconnection before retrying
- Bug Fix: SMB shares with user-variable paths (e.g. `/home/%U`) caused directory aggregate lookups to fail
- Bug Fix: Login page credentials were sent as a GET request instead of POST
- Enhancement: Audit plugin now monitors syslog connection status and generates alerts when the connection is established or lost
- Enhancement: Email server port field in the Web UI is now a dropdown with standard SMTP ports (25, 587, 465)

## 7.2.1
- New: Web UI introduced for managing QumuloAlerts configuration
