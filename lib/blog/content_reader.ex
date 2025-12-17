defmodule Blog.ContentReader do
  @doc """
  Reads all files from the configured posts directory.
  """

  defp posts_dir(), do: Application.get_env(:blog, :posts_dir)

  def read_all_posts do
    Path.wildcard(posts_dir() <> "/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&parse_content/1)
    |> Enum.reject(&(&1 == :ignore))
  end

  defp parse_content(path) do
    ext = Path.extname(path)

    cond do
      ext in [".md", ".mdx"] ->
        {:post, read_post(path)}

      ext in [".html", ".jpg", ".png", ".jpeg", ".mp4"] ->
        {:default, Path.relative_to(path, posts_dir())}

      true ->
        :ignore
    end
  end

  defp read_post(file_path) do
    raw_content = File.read!(file_path)

    doc =
      MDEx.parse_document!(raw_content,
        extension: [shortcodes: true, front_matter_delimiter: "---"]
      )

    slug = Path.basename(file_path, Path.extname(file_path))
    path = Path.relative_to(file_path, posts_dir()) |> Path.dirname()

    %{
      slug: slug,
      path: path,
      frontmatter: parse_frontmatter(doc),
      html_body: doc |> MDEx.to_html!(),
      url:
        case slug do
          # TODO: make images in articles works without trailing slash? how is it handled on my old blog? and in Astro?
          "index" -> path <> "/"
          _ -> Path.join([path, "#{slug}.html"])
        end
    }
  end

  defp parse_frontmatter(%MDEx.Document{} = doc) do
    %MDEx.FrontMatter{literal: text} = doc[MDEx.FrontMatter] |> List.first()

    frontmatter =
      text
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, acc ->
        case String.split(line, ":", parts: 2) do
          [key, val] -> Map.put(acc, String.to_atom(String.trim(key)), String.trim(val))
          _ -> acc
        end
      end)

    %{title: frontmatter.title, date: parse_date!(frontmatter.date), author: frontmatter.author}
  end

  defp parse_date!(date) when is_binary(date) do
    {:ok, date} = Date.from_iso8601(date)
    date
  end
end
