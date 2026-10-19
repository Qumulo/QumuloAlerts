# QumuloAlerts Changelog

## 7.2.6
- Bug Fix: Replication plugin sent malformed OpenMetrics messages — the label set was closed with a trailing comma instead of a space before the value, causing the Metrics consumer to fail parsing and silently drop all replication metrics
- Bug Fix: `y_update_database.sql.add` used `=` instead of `IN` when matching multiple event names, causing the `NotifyHardware` notification group to be created with no associated events
- Improvement: Publisher and consumer plugin alerting logic overhauled — all alert callbacks now carry correct severity levels, and consumers handle all severity values without risk of crash
- Enhancement: Replication plugin now sends an informational alert when a replication error clears
- Enhancement: Default Quota configuration now supports user email notification — administrators can specify email addresses and enable user notification directly on default quota prefix rules via the Web UI
- Enhancement: Log level for all running containers can now be changed at runtime without restarting services
- Enhancement: Quota and soft quota plugins now send an informational alert when usage drops back below alert thresholds — administrators receive a notification that the quota has returned to normal
- New: Cluster health plugin monitors cluster reachability and sends a critical alert when all configured floating IPs become unreachable, and an informational recovery alert when the cluster becomes reachable again; alerts only fire on state transitions so a sustained outage generates exactly one alert
- New: Web UI displays an "update available" notice in the sidebar when a newer release is published, linking to the Qumulo Alerts upgrade guide; version is checked against GitHub releases once per week and cached so no network calls are made beyond that
- New: Container health plugin monitors all running Docker containers and sends a critical alert when any managed container stops or its Docker health check reports unhealthy, and an informational recovery alert when the container returns to a running healthy state; state is tracked across poll cycles so a sustained outage generates exactly one alert
- New: Quorum plugin monitors cluster quorum health via the debug API and alerts on four state transitions — quorum abandoned (critical), quorum restored (informational), quorum degraded with nodes out (warning), and all nodes back in quorum (informational); continuous quorum status and node-count metrics are sent to InfluxDB on every poll, and quorum formation time in seconds is recorded as a separate InfluxDB data point each time quorum is restored

## 7.2.5
- Fix: Alerts container crashed on startup due to an incompatibility between fastapi-pagination
- Fix: Email address fields on quota, default quota, and soft quota alerts were limited to 255 characters (VARCHAR), columns expanded to TEXT with a migration for existing deployments
- Update: Grafana updated to 11.2.10-security-01

## 7.2.4
- Fix: Removed `PRIVILEGE_SNAPSHOT_CALCULATE_USED_CAPACITY_READ` as a required cluster privilege — this privilege no longer exists in newer Qumulo Core releases, causing cluster verification to fail on upgrade
- Enhancement: Improved internal release versioning to support greater flexibility in how QumuloAlerts and Qumulo Core versions are aligned

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
