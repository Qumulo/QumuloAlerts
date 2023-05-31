use alerts;

# Pre-populate the Associative Exchange Keys

insert into assoc_exchange(exchangeinfo_id, exchangekey_id)
       select l.id as exchangeinfo_id, t.id as exchangekey_id
       from exchangeinfo l
       inner join exchangekey t;
