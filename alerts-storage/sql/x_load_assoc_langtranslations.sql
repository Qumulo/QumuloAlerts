use alerts;

# Pre-populate the Associative Language Translations table

insert into assoc_langtranslations(lang_id, translations_id)
       select l.id as lang_id, t.id as translations_id
       from languages l
       inner join lang_translations t
       where l.locale = t.locale;
