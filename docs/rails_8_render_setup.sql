CREATE TABLE solid_cable_messages (
                                      id bigserial PRIMARY KEY,
                                      channel bytea NOT NULL,
                                      payload bytea NOT NULL,
                                      created_at timestamp NOT NULL,
                                      channel_hash bigint NOT NULL
);

-- Índices
CREATE INDEX index_solid_cable_messages_on_channel
    ON solid_cable_messages (channel);

CREATE INDEX index_solid_cable_messages_on_channel_hash
    ON solid_cable_messages (channel_hash);

CREATE INDEX index_solid_cable_messages_on_created_at
    ON solid_cable_messages (created_at);


CREATE TABLE solid_cache_entries (
                                     id bigserial PRIMARY KEY,
                                     key bytea NOT NULL,
                                     value bytea NOT NULL,
                                     created_at timestamp NOT NULL,
                                     key_hash bigint NOT NULL,
                                     byte_size integer NOT NULL
);


-- Índices
CREATE INDEX index_solid_cache_entries_on_byte_size
    ON solid_cache_entries (byte_size);

CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash
    ON solid_cache_entries (key_hash);

CREATE INDEX index_solid_cache_entries_on_key_hash_and_byte_size
    ON solid_cache_entries (key_hash, byte_size);



-- solid_queue_jobs
CREATE TABLE solid_queue_jobs (
                                  id bigserial PRIMARY KEY,
                                  queue_name varchar NOT NULL,
                                  class_name varchar NOT NULL,
                                  arguments text,
                                  priority integer NOT NULL DEFAULT 0,
                                  active_job_id varchar,
                                  scheduled_at timestamp,
                                  finished_at timestamp,
                                  concurrency_key varchar,
                                  created_at timestamp NOT NULL,
                                  updated_at timestamp NOT NULL
);

CREATE INDEX index_solid_queue_jobs_on_active_job_id ON solid_queue_jobs (active_job_id);
CREATE INDEX index_solid_queue_jobs_on_class_name ON solid_queue_jobs (class_name);
CREATE INDEX index_solid_queue_jobs_on_finished_at ON solid_queue_jobs (finished_at);
CREATE INDEX index_solid_queue_jobs_for_filtering ON solid_queue_jobs (queue_name, finished_at);
CREATE INDEX index_solid_queue_jobs_for_alerting ON solid_queue_jobs (scheduled_at, finished_at);

-- solid_queue_blocked_executions
CREATE TABLE solid_queue_blocked_executions (
                                                id bigserial PRIMARY KEY,
                                                job_id bigint NOT NULL,
                                                queue_name varchar NOT NULL,
                                                priority integer NOT NULL DEFAULT 0,
                                                concurrency_key varchar NOT NULL,
                                                expires_at timestamp NOT NULL,
                                                created_at timestamp NOT NULL
);

CREATE INDEX index_solid_queue_blocked_executions_for_release
    ON solid_queue_blocked_executions (concurrency_key, priority, job_id);
CREATE INDEX index_solid_queue_blocked_executions_for_maintenance
    ON solid_queue_blocked_executions (expires_at, concurrency_key);
CREATE UNIQUE INDEX index_solid_queue_blocked_executions_on_job_id
    ON solid_queue_blocked_executions (job_id);

-- solid_queue_claimed_executions
CREATE TABLE solid_queue_claimed_executions (
                                                id bigserial PRIMARY KEY,
                                                job_id bigint NOT NULL,
                                                process_id bigint,
                                                created_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_claimed_executions_on_job_id ON solid_queue_claimed_executions (job_id);
CREATE INDEX index_solid_queue_claimed_executions_on_process_id_and_job_id
    ON solid_queue_claimed_executions (process_id, job_id);

-- solid_queue_failed_executions
CREATE TABLE solid_queue_failed_executions (
                                               id bigserial PRIMARY KEY,
                                               job_id bigint NOT NULL,
                                               error text,
                                               created_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_failed_executions_on_job_id ON solid_queue_failed_executions (job_id);

-- solid_queue_pauses
CREATE TABLE solid_queue_pauses (
                                    id bigserial PRIMARY KEY,
                                    queue_name varchar NOT NULL,
                                    created_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_pauses_on_queue_name ON solid_queue_pauses (queue_name);

-- solid_queue_processes
CREATE TABLE solid_queue_processes (
                                       id bigserial PRIMARY KEY,
                                       kind varchar NOT NULL,
                                       last_heartbeat_at timestamp NOT NULL,
                                       supervisor_id bigint,
                                       pid integer NOT NULL,
                                       hostname varchar,
                                       metadata text,
                                       created_at timestamp NOT NULL,
                                       name varchar NOT NULL
);

CREATE INDEX index_solid_queue_processes_on_last_heartbeat_at ON solid_queue_processes (last_heartbeat_at);
CREATE UNIQUE INDEX index_solid_queue_processes_on_name_and_supervisor_id
    ON solid_queue_processes (name, supervisor_id);
CREATE INDEX index_solid_queue_processes_on_supervisor_id ON solid_queue_processes (supervisor_id);

-- solid_queue_ready_executions
CREATE TABLE solid_queue_ready_executions (
                                              id bigserial PRIMARY KEY,
                                              job_id bigint NOT NULL,
                                              queue_name varchar NOT NULL,
                                              priority integer NOT NULL DEFAULT 0,
                                              created_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_ready_executions_on_job_id ON solid_queue_ready_executions (job_id);
CREATE INDEX index_solid_queue_poll_all ON solid_queue_ready_executions (priority, job_id);
CREATE INDEX index_solid_queue_poll_by_queue ON solid_queue_ready_executions (queue_name, priority, job_id);

-- solid_queue_recurring_executions
CREATE TABLE solid_queue_recurring_executions (
                                                  id bigserial PRIMARY KEY,
                                                  job_id bigint NOT NULL,
                                                  task_key varchar NOT NULL,
                                                  run_at timestamp NOT NULL,
                                                  created_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_job_id ON solid_queue_recurring_executions (job_id);
CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_task_key_and_run_at
    ON solid_queue_recurring_executions (task_key, run_at);

-- solid_queue_recurring_tasks
CREATE TABLE solid_queue_recurring_tasks (
                                             id bigserial PRIMARY KEY,
                                             key varchar NOT NULL,
                                             schedule varchar NOT NULL,
                                             command varchar(2048),
                                             class_name varchar,
                                             arguments text,
                                             queue_name varchar,
                                             priority integer DEFAULT 0,
                                             static boolean NOT NULL DEFAULT true,
                                             description text,
                                             created_at timestamp NOT NULL,
                                             updated_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_recurring_tasks_on_key ON solid_queue_recurring_tasks (key);
CREATE INDEX index_solid_queue_recurring_tasks_on_static ON solid_queue_recurring_tasks (static);

-- solid_queue_scheduled_executions
CREATE TABLE solid_queue_scheduled_executions (
                                                  id bigserial PRIMARY KEY,
                                                  job_id bigint NOT NULL,
                                                  queue_name varchar NOT NULL,
                                                  priority integer NOT NULL DEFAULT 0,
                                                  scheduled_at timestamp NOT NULL,
                                                  created_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_scheduled_executions_on_job_id ON solid_queue_scheduled_executions (job_id);
CREATE INDEX index_solid_queue_dispatch_all
    ON solid_queue_scheduled_executions (scheduled_at, priority, job_id);

-- solid_queue_semaphores
CREATE TABLE solid_queue_semaphores (
                                        id bigserial PRIMARY KEY,
                                        key varchar NOT NULL,
                                        value integer NOT NULL DEFAULT 1,
                                        expires_at timestamp NOT NULL,
                                        created_at timestamp NOT NULL,
                                        updated_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_semaphores_on_key ON solid_queue_semaphores (key);
CREATE INDEX index_solid_queue_semaphores_on_key_and_value ON solid_queue_semaphores (key, value);
CREATE INDEX index_solid_queue_semaphores_on_expires_at ON solid_queue_semaphores (expires_at);

-- Foreign keys
ALTER TABLE solid_queue_blocked_executions
    ADD CONSTRAINT fk_blocked_jobs FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;

ALTER TABLE solid_queue_claimed_executions
    ADD CONSTRAINT fk_claimed_jobs FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;

ALTER TABLE solid_queue_failed_executions
    ADD CONSTRAINT fk_failed_jobs FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;

ALTER TABLE solid_queue_ready_executions
    ADD CONSTRAINT fk_ready_jobs FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;

ALTER TABLE solid_queue_recurring_executions
    ADD CONSTRAINT fk_recurring_jobs FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;

ALTER TABLE solid_queue_scheduled_executions
    ADD CONSTRAINT fk_scheduled_jobs FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;
