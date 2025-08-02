use alerts;

# Load the exchange info into the DB

INSERT INTO exchangeinfo
       (cluster, port, vhost, exchange, username, password)
   values
       ('exchange', 5672, 'QumuloProd', 'com.qumulo.alerts', 'qumulo', 'Admin123');

# Load the exchange keys into the DB

INSERT INTO exchangekey
       (name, type, routing_key, metrics_key, queue)
   values
       ('Collector', 'Collector', 'CollectorMessage', 'MetricsMessage', 'Collector'),
       ('Metrics', 'Consumer', '', 'MetricsMessage', 'Metrics'),
       ('EMail', 'Consumer', 'CollectorMessage', '', 'EMail'),
       ('ClickSend', 'Consumer', 'CollectorMessage', '', 'ClickSend'),
       ('IFTTT', 'Consumer', 'CollectorMessage', '', 'IFTTT'),
       ('SNMP', 'Consumer', 'CollectorMessage', '', 'SNMP');
