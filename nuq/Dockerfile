# Firecrawl NUQ (New Universal Queue) PostgreSQL database
# Adapted from: https://github.com/firecrawl/firecrawl/tree/main/apps/nuq-postgres
# PostgreSQL 17 + pg_cron for automated job queue maintenance
ARG PG_MAJOR=17
FROM postgres:${PG_MAJOR}

# hadolint ignore=SC2086
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    "postgresql-${PG_MAJOR}-cron"; \
    rm -rf /var/lib/apt/lists/*

# pg_cron requires cron.database_name set at server start (not runtime-configurable).
# Using 'postgres' matches the official Firecrawl defaults.
RUN set -eux; \
    conf_sample="/usr/share/postgresql/${PG_MAJOR}/postgresql.conf.sample"; \
    sed -ri "s/^#?shared_preload_libraries\s*=.*/shared_preload_libraries = 'pg_cron'/" "$conf_sample"; \
    printf "\n# Added for pg_cron\ncron.database_name = 'postgres'\n" >> "$conf_sample"

COPY nuq.sql /docker-entrypoint-initdb.d/010-nuq.sql
