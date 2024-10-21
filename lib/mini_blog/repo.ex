defmodule MiniBlog.Repo do
  use Ecto.Repo,
    otp_app: :mini_blog,
    adapter: Ecto.Adapters.Postgres
end
