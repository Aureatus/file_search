defmodule FileSearch do
  @moduledoc """
  Documentation for FileSearch
  """

  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [by_type: :boolean])
    IO.inspect(opts)

    if(opts[:by_type]) do
      by_extension(Path.dirname(__DIR__))
      |> IO.inspect()
    else
      all(Path.dirname(__DIR__))
      |> IO.puts()
    end
  end

  @doc """
  Find all nested files.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
    /sub2
      file2.txt
    /sub3
      file3.txt
    file4.txt

  It would return:

  ["file1.txt", "file2.txt", "file3.txt", "file4.txt"]
  """
  def all(folder) do
    files = File.ls!(folder)

    Enum.map(files, fn file ->
      path = Path.join(folder, file)

      if File.dir?(path) do
        all(path)
      else
        file
      end
    end)
    |> List.flatten()
  end

  @doc """
  Find all nested files and categorize them by their extension.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
      file1.png
    /sub2
      file2.txt
      file2.png
    /sub3
      file3.txt
      file3.jpg
    file4.txt

  The exact order and return value are up to you as long as it finds all files
  and categorizes them by file extension.

  For example, it might return the following:

  %{
    ".txt" => ["file1.txt", "file2.txt", "file3.txt", "file4.txt"],
    ".png" => ["file1.png", "file2.png"],
    ".jpg" => ["file3.jpg"]
  }
  """
  def by_extension(folder) do
    all(folder)
    |> Enum.group_by(fn x -> Path.extname(x) end)
  end
end
