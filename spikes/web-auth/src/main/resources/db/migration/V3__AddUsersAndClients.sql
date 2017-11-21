-- Add in call centres
INSERT INTO callcenters VALUES (
    0,
    'StarTrack',
    'startrack.com.au'
), (
    1,
    'NewsCorp',
    'newscorp.com.au'
);

-- Add in sample users
INSERT INTO users VALUES (
    'someone@startrack.com.au',
    '$2a$10$iPr/oxyTveEbCIuXg4PP5.qbA0pDIyM0t/tnJErHeHyqYZIuY3zlW', --password
    true,
    0
), (
    'someone@newscorp.com.au',
    '$2a$10$Z3kUUn7xIwEBKKzMRWdsN.SpHeYy4yhrdIyiC7iEnRLOMqnq1R73K', --password
    true,
    1
);
INSERT INTO users VALUES (
    'admin',                                                             -- Username
    '$2a$10$Z3kUUn7xIwEBKKzMRWdsN.SpHeYy4yhrdIyiC7iEnRLOMqnq1R73K',      -- Password (BCrypt hash of 'password')
    true,                                                                 -- User account enabled?
    1
);

-- Add sample role
INSERT INTO roles VALUES (
    'USER'
);

-- Assign the USER role to 'admin'
INSERT INTO users_roles VALUES
  ('someone@startrack.com.au', 'USER'),
  ('someone@newscorp.com.au', 'USER');

-- Add sample client application
INSERT INTO oauth_client_details VALUES (
    'ceres-front-end',                                                   -- Client ID
    'ceres-back-end',                                                    -- List of allowed Resource Servers
    '$2b$10$WdT56VbOkG6OiDqNnzriqu3Rl7LlG2ScnDibc40dtWcjlu/BEAHTu',      -- BCrypt hash of "ceres-is-awesome"
    'read,write',                                                        -- Access scopes
    'client_credentials,password,refresh_token,authorization_code',      -- Authorised grant types
    NULL,                                                                -- Redirect URI
    'ROLE_CLIENT,ROLE_TRUSTED_CLIENT',                                   -- Client roles
    36000,                                                               -- Token TTL
    -1,                                                                  -- Refresh token TTL
    NULL,                                                                -- Additional information
    true                                                                 -- Auto-approve scopes?
);