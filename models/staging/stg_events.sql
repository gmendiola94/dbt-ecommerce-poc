{{
  config(
    materialized = 'table',
    )
}}

select
    id,
    session_id,
    city,
    created_at,
    ip_address,
    uri,
    traffic_source,
    sequence_number,
    event_type,
    user_id,
    browser,
    state,
    postal_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_events_hashid
from {{ source('airbyte_schema', 'events') }}
