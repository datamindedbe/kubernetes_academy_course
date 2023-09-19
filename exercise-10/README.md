# Statefulsets

## Steps
Use https://github.com/sixeyed/widgetario/tree/main/src/db/postgres-replicated as inspiration for how to start the statefulset

- create postgres db statefulset
-- image: widgetario/products-db:postgres-replicated
-- port: 5432
-- requires a volumemount: /var/lib/postgresql/data
-- requires secrets: POSTGRES_PASSWORD and PGPASSWORD
