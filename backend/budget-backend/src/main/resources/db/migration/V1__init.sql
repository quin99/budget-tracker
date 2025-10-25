CREATE TABLE IF NOT EXISTS app_user (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS account (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    name VARCHAR(120) NOT NULL,
    type VARCHAR(40) NOT NULL, -- CASH, CHECKING, CREDIT
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


CREATE INDEX IF NOT EXISTS idx_account_user ON account(user_id);


CREATE TABLE IF NOT EXISTS category (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    name VARCHAR(120) NOT NULL,
    type VARCHAR(20) NOT NULL -- INCOME or EXPENSE
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_category_user_name ON category(user_id, name);


CREATE TABLE IF NOT EXISTS txn (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    account_id BIGINT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    category_id BIGINT NULL REFERENCES category(id) ON DELETE SET NULL,
    amount_cents BIGINT NOT NULL, -- store money as integer cents
    txn_date DATE NOT NULL,
    memo VARCHAR(255)
);
CREATE INDEX IF NOT EXISTS idx_txn_user_date ON txn(user_id, txn_date);


CREATE TABLE IF NOT EXISTS budget (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    month_key CHAR(7) NOT NULL, -- YYYY-MM
    category_id BIGINT NOT NULL REFERENCES category(id) ON DELETE CASCADE,
    planned_cents BIGINT NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_budget_user_month_cat ON budget(user_id, month_key, category_id);