Rails.application.middleware.insert_before(
  ActionDispatch::Session::CacheStore,
  ActionDispatch::Cookies
)

Rails.application.config.session_store :cookie_store, key: "_one_super_ten_session", expire_after: 90.minutes