use alerts;

# Alarms Plugins

insert into plugins
       (name, category, description)
   values
       ('CPU', 'Alarms', 'Get CPU Overtemp'),
       ('Disks', 'Alarms', 'Get Disk State Information'),
       ('Fans', 'Alarms', 'Get Fan Failures'),
       ('Network', 'Alarms', 'Get Network Link Failures'),
       ('Nodes', 'Alarms', 'Get Cluster Node Failures');

# Alerts Plugins

insert into plugins
       (name, category, description)
   values
       ('AD', 'Alerts', 'Get Active Directory State'),
       ('Audit', 'Alerts', 'Get Audit Status'),
       ('Capacity', 'Alerts', 'Get Cluster Volume Capacity'),
       ('Exports', 'Alerts', 'Get NFS Exports'),
       ('FTP', 'Alerts', 'Get FTP Status'),
       ('Groups', 'Alerts', 'Get Local Groups'),
       ('Monitoring', 'Alerts', 'Get Cloud Monitoring and Remote Support Information'),
       ('Quotas', 'Alerts', 'Get Quota Notifications'),
       ('Restriper', 'Alerts', 'Get Restriper Status Information'),
       ('Shares', 'Alerts', 'Get SMB Shares'),
       ('Users', 'Alerts', 'Get Local Users');

# Informational

insert into plugins
       (name, category, description, frequency)
   values
       ('Metrics', 'Informational', 'Get all of the info from the Metrics API', 5),
       ('OSUpgrade', 'Informational', 'Get OS Upgrade Information', 5);
