create table users (
    username varchar(50) not null primary key,
    password varchar(255) not null,
    enabled boolean not null
);

CREATE TABLE roles (
    role_name varchar(50) primary key
);

CREATE TABLE users_roles (
    users_username varchar(50) references users,
    roles_role_name varchar(50) references roles,

    PRIMARY KEY (users_username, roles_role_name)
);

create table groups (
    id bigint primary key,
    group_name varchar(50) not null
);

create table group_authorities (
    group_id bigint not null,
    authority varchar(50) not null,

    constraint fk_group_authorities_group foreign key(group_id) references groups(id)
);

create table group_members (
    id bigint primary key,
    username varchar(50) not null,
    group_id bigint not null,

    constraint fk_group_members_group foreign key(group_id) references groups(id)
);

create table persistent_logins (
    username varchar(64) not null,
    series varchar(64) primary key,
    token varchar(64) not null,
    last_used timestamp not null
);

create table oauth_client_details (
    client_id varchar(255) primary key,
    resource_ids varchar(255),
    client_secret varchar(255),
    scope varchar(255),
    authorized_grant_types varchar(255),
    web_server_redirect_uri varchar(255),
    authorities varchar(255),
    access_token_validity integer,
    refresh_token_validity integer,
    additional_information varchar(4096),
    autoapprove varchar(255)
);
 
create table oauth_client_token (
    token_id varchar(255),
    token bytea,
    authentication_id varchar(255) primary key,
    user_name varchar(255),
    client_id varchar(255)
);
 
create table oauth_access_token (
    token_id varchar(255),
    token bytea,
    authentication_id varchar(255) primary key,
    user_name varchar(255),
    client_id varchar(255),
    authentication bytea,
    refresh_token varchar(255)
);
 
create table oauth_refresh_token (
    token_id varchar(255),
    token bytea,
    authentication bytea
);
 
create table oauth_code (
    code varchar(255),
    authentication bytea
);
 
create table oauth_approvals (
    userId varchar(255),
    clientId varchar(255),
    scope varchar(255),
    status varchar(10),
    expiresAt timestamp,
    lastModifiedAt timestamp
);

create table ClientDetails (
    appId varchar(255) primary key,
    resourceIds varchar(255),
    appSecret varchar(255),
    scope varchar(255),
    grantTypes varchar(255),
    redirectUrl varchar(255),
    authorities varchar(255),
    access_token_validity integer,
    refresh_token_validity integer,
    additionalInformation varchar(4096),
    autoApproveScopes varchar(255)
);

create table acl_sid (
    id bigserial not null primary key,
    principal boolean not null,
    sid varchar(100) not null,
    constraint unique_uk_1 unique(sid,principal)
);

create table acl_class (
    id bigserial not null primary key,
    class varchar(100) not null,
    constraint unique_uk_2 unique(class)
);

create table acl_object_identity (
    id bigserial primary key,
    object_id_class bigint not null,
    object_id_identity bigint not null,
    parent_object bigint,
    owner_sid bigint,
    entries_inheriting boolean not null,
    constraint unique_uk_3 unique(object_id_class,object_id_identity),
    constraint foreign_fk_1 foreign key(parent_object) references acl_object_identity(id),
    constraint foreign_fk_2 foreign key(object_id_class) references acl_class(id),
    constraint foreign_fk_3 foreign key(owner_sid) references acl_sid(id)
);

create table acl_entry (
    id bigserial primary key,
    acl_object_identity bigint not null,
    ace_order int not null,
    sid bigint not null,
    mask integer not null,
    granting boolean not null,
    audit_success boolean not null,
    audit_failure boolean not null,
    constraint unique_uk_4 unique(acl_object_identity,ace_order),
    constraint foreign_fk_4 foreign key(acl_object_identity) references acl_object_identity(id),
    constraint foreign_fk_5 foreign key(sid) references acl_sid(id)
);