defmodule Blog.ContentReader do
  @doc """
  Reads all files from the configured posts directory.
  """
  def read_all_posts do
    posts_dir = Application.get_env(:blog, :posts_dir)

    posts_dir
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".md"))
    |> Enum.map(&Path.join(posts_dir, &1))
    |> Enum.map(&read_post/1)
    |> Enum.sort_by(& &1.frontmatter.date, {:desc, Date})
  end

  defp read_post(file_path) do
    raw_content = File.read!(file_path)

    doc =
      MDEx.parse_document!(raw_content,
        extension: [shortcodes: true, front_matter_delimiter: "---"]
      )

    slug = Path.basename(file_path, ".md")

    %{
      slug: slug,
      frontmatter: %{title: _, date: _, author: _} = parse_frontmatter(doc),
      html_body: doc |> MDEx.to_html!(),
      url: "/#{slug}.html"
    }
  end

  defp parse_frontmatter(%MDEx.Document{} = doc) do
    %MDEx.FrontMatter{literal: text} = doc[MDEx.FrontMatter] |> List.first()

    text
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      case String.split(line, ":", parts: 2) do
        [key, val] -> Map.put(acc, String.to_atom(String.trim(key)), String.trim(val))
        _ -> acc
      end
    end)
  end
end
