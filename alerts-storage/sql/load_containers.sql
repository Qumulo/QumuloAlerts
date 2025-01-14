use alerts;

# Create the containers that belong to Qumulo Alerts

insert into containers
       (name,
       description,
       dynamic_class,
       container_type,
       image,
       tags,
       command,
       hostname,
       network,
       ports,
       volumes,
       environment,
       initial,
       start_order,
       quantity,
       restart_policy)
   values
       ('Collector',
       'Collector - Communicates with a single cluster and retrieves alarms / alerts / and other information',
       'Collector',
       'Collector',
       'ghcr.io/qumulo/collector',
       'latest',
       './Collector.py --cluster {cluster_name} --username {db_username} --password {db_password} --host {db_host} --port {db_port} --log {loglevel} --routing_key {routing_key} --vhost {db_vhost} --plugins /code/plugins',
       'collector-{0}',
       'qumuloalerts',
       '{}',
       '{}',
       '{}',
       false,
       0,
       1,
       '{"Name": "no"}'),

       ('Metrics',
       'Metrics - Aggregate all alarms, alerts, and metrics into InfluxDB',
       'Metrics',
       'Consumer',
       'ghcr.io/qumulo/metrics',
       'latest',
       './AlertsMetrics.py --username {db_username} --password {db_password} --host {db_host} --port {db_port} --log {loglevel} --routing_key {routing_key} --vhost {db_vhost} --plugins /code/plugins',
       null,
       'qumuloalerts',
       '{}',
       '{}',
       '{}',
       true,
       2,
       1,
       '{"Name": "no"}'),

       ('EMail',
       'Email - Format alarms / alerts / and other information into native language and send via email',
       'EMail',
       'Consumer',
       'ghcr.io/qumulo/email',
       'latest',
       './AlertsEmail.py --username {db_username} --password {db_password} --host {db_host} --port {db_port} --log {loglevel} --routing_key {routing_key} --vhost {db_vhost} --plugins /code/plugins',
       null,
       'qumuloalerts',
       '{}',
       '{}',
       '{}',
       false,
       0,
       1,
       '{"Name": "no"}'),

       ('ClickSend',
       'ClickSend - Format alarms / alerts / and other information into native language and send via SMS',
       'ClickSend',
       'Consumer',
       'ghcr.io/qumulo/clicksend',
       'latest',
       './AlertsClickSend.py --username {db_username} --password {db_password} --host {db_host} --port {db_port} --log {loglevel} --routing_key {routing_key} --vhost {db_vhost} --plugins /code/plugins',
       null,
       'qumuloalerts',
       '{}',
       '{}',
       '{}',
       false,
       0,
       1,
       '{"Name": "no"}'),

       ('IFTTT',
       'IFTTT - Format alarms / alerts / and other information into native language and send via IFTTT Webhook',
       'IFTTT',
       'Consumer',
       'ghcr.io/qumulo/ifttt',
       'latest',
       './AlertsIFTTT.py --username {db_username} --password {db_password} --host {db_host} --port {db_port} --log {loglevel} --routing_key {routing_key} --vhost {db_vhost} --plugins /code/plugins',
       null,
       'qumuloalerts',
       '{}',
       '{}',
       '{}',
       false,
       0,
       1,
       '{"Name": "no"}');

