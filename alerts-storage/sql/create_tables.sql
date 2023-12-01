use alerts;

# Required Role permission definitions

create table if not exists rolesrequired (
       id int not null primary key auto_increment,
       role_name varchar(64) not null unique);

# AD account record

create table if not exists adserver (
       id int not null primary key auto_increment,
       server_name varchar(128) not null unique,
       login_name varchar(128) not null,
       login_password varchar(256) not null,
       search_base varchar(256) not null);

# User definitions

create table if not exists users (
       id int not null primary key auto_increment,
       full_name varchar(100) not null,
       username varchar(32) not null unique,
       hashed_password varchar(256) not null,
       email varchar(64),
       phone varchar(32),
       ifttt_event varchar(64),
       language varchar(32),
       timezone varchar(32),
       disabled boolean,
       protected boolean,
       can_change_password boolean);

create index email on users (email);

# Clusters to be monitored

create table if not exists clusters (
       id int not null primary key auto_increment,
       name varchar(100) not null unique,
       port int default 8000,
       token varchar(256),
       nlb boolean default 0,
       frequency int default 60);

# Plugins available

create table if not exists plugins (
       id int not null primary key auto_increment,
       name varchar(32) not null unique,
       category varchar(32) not null,
       description varchar(256) not null,
       frequency int);

# Quotas to be monitored

create table if not exists quotas (
       id int not null primary key auto_increment,
       quota_path varchar(1024) not null unique,
       critical int not null,
       error int not null,
       warning int not null,
       user_notification boolean default 0,
       admin_notification boolean default 1,
       user_mode varchar(32),
       admin_email varchar(256),
       email_suffix varchar(32),
       user_email varchar(256));

# Default Quota thresholds to be monitored

create table if not exists defaultquota (
       id int not null primary key auto_increment,
       quota_prefix varchar(1024) not null unique,
       critical int not null,
       error int not null,
       warning int not null,
       user_notification boolean default 0,
       admin_notification boolean default 1,
       admin_email varchar(256),
       email_suffix varchar(32),
       user_mode varchar(32) default 'owner');

# Capacity thresholds to be monitored. This is the capacity of the entire cluster

create table if not exists capacity (
       id int not null primary key auto_increment,
       critical int not null,
       error int not null,
       warning int not null);

# Soft Quotas to be monitored

create table if not exists softquotas (
       id int not null primary key auto_increment,
       directory_path varchar(1024) not null unique,
       capacity bigint not null,
       critical int not null,
       error int not null,
       warning int not null,
       user_notification boolean default 0,
       admin_notification boolean default 1,
       user_mode varchar(32),
       admin_email varchar(256),
       email_suffix varchar(32),
       user_email varchar(256));

# ClickSend SMS configuration

create table if not exists clicksendserver (
       id int not null primary key auto_increment,
       username varchar(64) not null,
       token varchar(256) not null,
       senderid varchar(64) not null,
       to_address varchar(64),
       language varchar(15),
       timezone varchar(32));

# IFTTT configuration

create table if not exists iftttserver (
       id int not null primary key auto_increment,
       token varchar(256) not null,
       language varchar(15),
       timezone varchar(32));

# EMail server configuration

create table if not exists emailserver (
       id int not null primary key auto_increment,
       from_address varchar(64) not null,
       to_address varchar(64),
       login varchar(64),
       password varchar(128),
       server varchar(128) not null unique,
       port int not null,
       security varchar(10),
       language varchar(15),
       timezone varchar(32));

# Roles configuration

create table if not exists roles (
       id int not null primary key auto_increment,
       name varchar(64) not null unique,
       description varchar(128),
       protected boolean);

# Role Privileges configuration

create table if not exists roleprivileges (
       id int not null primary key auto_increment,
       name varchar(64) not null unique,
       description varchar(128) not null);

# NotifyGroup configuration

create table if not exists notifygroup (
       id int not null primary key auto_increment,
       name varchar(64) not null unique,
       description varchar(128),
       protected boolean);

# NotifyEvents configuration

create table if not exists notifyevents (
       id int not null primary key auto_increment,
       name varchar(64) not null unique,
       category varchar(64) not null,
       subcategory varchar(64) not null,
       description varchar(128) not null);

# Exchange Info - Info needed for the various processes to communicate with RabbitMQ

create table if not exists exchangeinfo (
       id int not null primary key auto_increment,
       cluster varchar(64) not null,
       port int not null,
       vhost varchar(64) not null,
       exchange varchar(64) not null,
       username varchar(64) not null,
       password varchar(64) not null);

# Exchange Keys - Individual key records for each process to communicate with RabbitMQ

create table if not exists exchangekey (
       id int not null primary key auto_increment,
       name varchar(64) not null unique,
       type varchar(32) not null,
       routing_key varchar(128) not null,
       metrics_key varchar(128) not null,
       queue varchar(64) not null);

# Container Management - This is where we define our docker containers

create table if not exists containers (
       id int not null primary key auto_increment,
       name varchar(64) not null unique,
       dynamic_class varchar(32),
       container_type varchar(32),
       description varchar(128),
       image varchar(64) not null,
       tags varchar(32),
       command varchar(256),
       hostname varchar(32),
       network varchar(32),
       ports varchar(256),
       volumes varchar(512),
       environment varchar(2048),
       initial boolean not null,
       start_order int not null,
       quantity int not null,
       restart_policy varchar(32));

# Languages

create table if not exists languages (
       id int not null primary key auto_increment,
       language varchar(64) not null,
       locale varchar(32) not null unique,
       translator varchar(64) not null,
       email varchar(64) not null,
       copyright varchar(128) not null,
       version int not null);

# Language translations

create table if not exists lang_translations (
       id int not null primary key auto_increment,
       locale varchar(64) not null,
       lookup_name varchar(64) not null,
       message varchar(1024) not null);

create unique index name on lang_translations (locale, lookup_name);

# Metrics connection to InfluxDB

create table if not exists metricsinfluxdb (
       id int not null primary key auto_increment,
       url varchar(256) not null,
       org varchar(64) not null,
       token varchar(1024) not null);

# Cluster / AD Server mapping

create table if not exists assoc_clusteradserver (
       cluster_id int not null,
       adserver_id int not null,
       primary key (cluster_id, adserver_id),
       foreign key (cluster_id) references clusters (id),
       foreign key (adserver_id) references adserver (id));

# Exchange Info / Exchange Keys mapping

create table if not exists assoc_exchange (
       exchangeinfo_id int not null,
       exchangekey_id int not null,
       primary key (exchangeinfo_id, exchangekey_id),
       foreign key (exchangeinfo_id) references exchangeinfo (id),
       foreign key (exchangekey_id) references exchangekey (id));

# Language / Language Translations mapping

create table if not exists assoc_langtranslations (
       lang_id int not null,
       translations_id int not null,
       primary key (lang_id, translations_id),
       foreign key (lang_id) references languages (id),
       foreign key (translations_id) references lang_translations (id));

# Cluster / Capacity mapping

create table if not exists assoc_clustercapacity (
       cluster_id int not null,
       capacity_id int not null,
       primary key (cluster_id, capacity_id),
       foreign key (cluster_id) references clusters (id),
       foreign key (capacity_id) references capacity (id));

# Cluster / Plugin mapping

create table if not exists assoc_clusterplugins (
       cluster_id int not null,
       plugin_id int not null,
       primary key (cluster_id, plugin_id),
       foreign key (cluster_id) references clusters (id),
       foreign key (plugin_id) references plugins (id));

# User / Roles mapping

create table if not exists assoc_userroles (
       user_id int not null,
       roles_id int not null,
       primary key (user_id, roles_id),
       foreign key (user_id) references users (id),
       foreign key (roles_id) references roles (id));

# Privileges / Roles mapping

create table if not exists assoc_roleprivileges (
       privilege_id int not null,
       roles_id int not null,
       primary key (privilege_id, roles_id),
       foreign key (privilege_id) references roleprivileges (id),
       foreign key (roles_id) references roles (id));

# User / NotifyGroup  mapping

create table if not exists assoc_usernotifygroups (
       user_id int not null,
       group_id int not null,
       primary key (user_id, group_id),
       foreign key (user_id) references users (id),
       foreign key (group_id) references notifygroup (id));

# NotifyEvents / NotifyGroup mapping

create table if not exists assoc_notifyevents (
       event_id int not null,
       group_id int not null,
       primary key (event_id, group_id),
       foreign key (event_id) references notifyevents (id),
       foreign key (group_id) references notifygroup (id));

# Quota / Cluster mapping

create table if not exists assoc_clusterquotas (
       cluster_id int not null,
       quota_id int not null,
       primary key (cluster_id, quota_id),
       foreign key (cluster_id) references clusters (id),
       foreign key (quota_id) references quotas (id));

# Soft Quota / Cluster mapping

create table if not exists assoc_clustersoftquotas (
       cluster_id int not null,
       softquota_id int not null,
       primary key (cluster_id, softquota_id),
       foreign key (cluster_id) references clusters (id),
       foreign key (softquota_id) references softquotas (id));
