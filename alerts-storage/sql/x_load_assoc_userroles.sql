use alerts;

# Pre-populate the Associative User / Roles mapping

insert into assoc_userroles(user_id, roles_id)
       select u.id as user_id, r.id as roles_id
       from users u
       inner join roles r
       where r.name not like 'Observers';

