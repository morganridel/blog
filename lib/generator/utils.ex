defmodule Generator.Utils do
  def parse_date!(date) when is_binary(date) do
    {:ok, date} = Date.from_iso8601(date)
    date
  end
end
