# See https://github.com/rails-on-services/apartment/issues/322

require "apartment/adapters/postgresql_adapter"

Apartment::Adapters::PostgresqlSchemaFromSqlAdapter::PSQL_DUMP_BLACKLISTED_STATEMENTS =
  (Apartment::Adapters::PostgresqlSchemaFromSqlAdapter::PSQL_DUMP_BLACKLISTED_STATEMENTS + [/\\restrict/i, /\\unrestrict/i]).freeze