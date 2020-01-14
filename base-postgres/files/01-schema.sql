DROP SCHEMA IF EXISTS app CASCADE;
CREATE SCHEMA app;
ALTER DATABASE postgres SET search_path=app,"$user",public;
