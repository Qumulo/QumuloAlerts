use alerts;

# Show all exchange keys used by RabbitMQ

create view if not exists view_exchangekey as
       select exchangeinfo.cluster as clustername,
              exchangeinfo.vhost as vhost,
	      exchangekey.name as name,
	      exchangekey.type as type,
	      exchangekey.queue as queue
	      from exchangeinfo
	      join assoc_exchange
	      on exchangeinfo.id = assoc_exchange.exchangeinfo_id
	      join exchangekey
	      on exchangekey.id = assoc_exchange.exchangekey_id;

# Show the ad server tied to a cluster

create view if not exists view_clusteradserver as
       select clusters.name as clustername,
              adserver.server_name as server_name,
              adserver.login_name as login_name,
              adserver.search_base as search_base
	      from clusters
	      join assoc_clusteradserver
	      on clusters.id = assoc_clusteradserver.cluster_id
	      join adserver
	      on adserver.id = assoc_clusteradserver.adserver_id;

# Show the capacity used in a cluster

create view if not exists view_clustercapacity as
       select clusters.name as clustername,
              capacity.critical as critical,
              capacity.error as error,
              capacity.warning as warning
	      from clusters
	      join assoc_clustercapacity
	      on clusters.id = assoc_clustercapacity.cluster_id
	      join capacity
	      on capacity.id = assoc_clustercapacity.capacity_id;

# Show all plugins used in a cluster

create view if not exists view_clusterplugins as
       select clusters.name as clustername,
              plugins.name as pluginname
	      from clusters
	      join assoc_clusterplugins
	      on clusters.id = assoc_clusterplugins.cluster_id
	      join plugins
	      on plugins.id = assoc_clusterplugins.plugin_id;

# Show all roles used by the users

create view if not exists view_userroles as
       select users.full_name as full_name,
       	      users.username as username,
       	      roles.name as roles
	      from users
	      join assoc_userroles
	      on users.id = assoc_userroles.user_id
	      join roles
	      on roles.id = assoc_userroles.roles_id;

# Show all privileges used by any role

create view if not exists view_roleprivileges as
       select roles.name as role_name,
       	      roleprivileges.name as privilege
	      from roles
	      join assoc_roleprivileges
	      on roles.id = assoc_roleprivileges.roles_id
	      join roleprivileges
	      on roleprivileges.id = assoc_roleprivileges.privilege_id;

# Show all notifygroups used by the users

create view if not exists view_usernotifygroups as
       select users.full_name as full_name,
       	      users.username as username,
       	      notifygroup.name as notifygroup
	      from users
	      join assoc_usernotifygroups
	      on users.id = assoc_usernotifygroups.user_id
	      join notifygroup
	      on notifygroup.id = assoc_usernotifygroups.group_id;

# Show all notifyevents used by any notifygroup

create view if not exists view_notifyevents as
       select notifygroup.name as notifygroup,
       	      notifyevents.name as event
	      from notifygroup
	      join assoc_notifyevents
	      on notifygroup.id = assoc_notifyevents.group_id
	      join notifyevents
	      on notifyevents.id = assoc_notifyevents.event_id;

# Show all quotas monitored on a cluster

create view if not exists view_clusterquotas as
       select clusters.name as clustername,
              quotas.quota_path as quota_path
	      from clusters
	      join assoc_clusterquotas
	      on clusters.id = assoc_clusterquotas.cluster_id
	      join quotas
	      on quotas.id = assoc_clusterquotas.quota_id;

# Show all soft quotas monitored on a cluster

create view if not exists view_clustersoftquotas as
       select clusters.name as clustername,
              softquotas.directory_path as softquota_path
	      from clusters
	      join assoc_clustersoftquotas
	      on clusters.id = assoc_clustersoftquotas.cluster_id
	      join softquotas
	      on softquotas.id = assoc_clustersoftquotas.softquota_id;

# Show all language translations

create view if not exists view_langtranslations as
       select languages.language as language,
       	      languages.locale as locale,
	      lang_translations.lookup_name as lookup_name,
	      lang_translations.message as message
	      from languages
	      join assoc_langtranslations
	      on languages.id = assoc_langtranslations.lang_id
	      join lang_translations
	      on lang_translations.id = assoc_langtranslations.translations_id;
