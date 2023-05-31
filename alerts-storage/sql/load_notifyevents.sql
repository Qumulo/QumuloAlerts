use alerts;

# Individual Event(s) for NotifyGroup

insert into notifyevents
       (name, category, subcategory, description)
   values
       ('NOTIFY_AD', 'Alerts', 'AD', 'Join/Leave Active Directory, plus any parameter changes'),
       ('NOTIFY_AUDIT', 'Alerts', 'Audit', 'Auditing enabled/disabled'),
       ('NOTIFY_CAPACITY', 'Alerts', 'Capacity', 'Notification when cluster has reached certain thresholds of capacity: I.E: 70, 80, 90%'),
       ('NOTIFY_CPU', 'Alarms', 'CPU', 'CPU Overtemp'),
       ('NOTIFY_DISKS', 'Alarms', 'Disks', 'Disk failure, removal, and replacement'),
       ('NOTIFY_EXPORTS', 'Alerts', 'Exports', 'NFS Export creation, deletion, and parameter changes'),
       ('NOTIFY_FANS', 'Alarms', 'Fans', 'Fan failure and replacement'),
       ('NOTIFY_FTP', 'Alerts', 'FTP', 'FTP enabled/disabled'),
       ('NOTIFY_GROUPS', 'Alerts', 'Groups', 'Creation, modification, or deletion of a Local Group'),
       ('NOTIFY_MONITORING', 'Alerts', 'Monitoring', 'Cloud Monitoring / Remote Support enabled/disabled and failure to connect'),
       ('NOTIFY_NETWORK', 'Alarms', 'Network', 'Network link failure and repair'),
       ('NOTIFY_NODES', 'Alarms', 'Nodes', 'Node failure, repair, and addition'),
       ('NOTIFY_OSUPGRADE', 'Informational', 'OSUpgrade', 'OS Upgraded from one revision to another'),
       ('NOTIFY_QUOTAS', 'Alerts', 'Quotas', 'Notification when a hard quota has reached certain thresholds of capacity: I.E: 70, 80, 90%'),
       ('NOTIFY_RESTRIPER', 'Alerts', 'Restriper', 'Restriper start, stop, and percentage completion'),
       ('NOTIFY_SHARES', 'Alerts', 'Shares', 'SMB Share creation, deletion, and parameter changes'),
       
       ('NOTIFY_USERS', 'Alerts', 'Users', 'Creation, modification, or delete of a Local User');
