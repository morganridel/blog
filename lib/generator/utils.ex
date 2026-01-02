defmodule Generator.Utils do
  def parse_date!(date) when is_binary(date) do
    {:ok, date} = Date.from_iso8601(date)
    date
  end

  def remove_trailing_slash(path) do
    String.trim_trailing(path, "/")
  end
end
