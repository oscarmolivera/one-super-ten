# 🔐 Encrypted Attributes Policy

## Purpose

To protect sensitive user and tenant data, we use **Active Record Encryption** built into Rails 8+.

## Configuration

Encryption keys are stored in `config/credentials.yml.enc`:

```yaml
active_record_encryption:
  primary_key: <%= ENV["ENCRYPTION_PRIMARY_KEY"] %>
  deterministic_key: <%= ENV["ENCRYPTION_DETERMINISTIC_KEY"] %>
  key_derivation_salt: <%= ENV["ENCRYPTION_KEY_DERIVATION_SALT"] %>
```
