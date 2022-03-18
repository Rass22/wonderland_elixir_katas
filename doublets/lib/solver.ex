defmodule Doublets.Solver do
  import String
  defp words do
    "./resources/words.txt"
      |> File.stream!
      |> Enum.to_list
  end
  def doublets(word1, word2) do
    cond do
      String.length(word1) == String.length(word2) ->
        leng = [word1 | doublets(word1, word2, words())]
        cond do
          Enum.member?(leng, "sin respuesta") -> []
          true -> leng
        end
      true -> []
    end
  end

  def doublets(word1, word2, dic) when word1 != word2 do
    hola = Enum.map(dic, &trim(&1))
      |> Enum.filter(fn x -> String.length(word1) == String.length(x) end) |> List.delete(word1)
    x = hd Enum.sort_by(hola, &{Simetric.Levenshtein.compare(&1, word1), Simetric.Levenshtein.compare(&1, word2)}, :asc) |> IO.inspect()
    dif_letra =  Enum.zip_reduce(String.to_charlist(word1), String.to_charlist(x), 0, fn x, y, acc ->
      cond do
      x != y -> acc + 1
      true -> acc
      end
    end)
    IO.inspect(word1)
    IO.inspect(x)
    IO.inspect(dif_letra)
    cond do
      dif_letra == 1 -> [x | doublets(x, word2, hola)]
      true -> ["sin respuesta"]
    end
  end
  def doublets(word1, word2, _) when word1 == word2 do
     []
  end
end
