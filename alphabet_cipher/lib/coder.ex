defmodule AlphabetCipher do
  @spec alphabet :: [{any, integer}]
  def alphabet() do
    'abcdefghijklmnopqrstuvwxyz'|> Enum.with_index
  end

  @spec encode(binary, binary) :: binary
  def encode(keyword, message) do
    keyword = keyword
    |> String.downcase() |> String.duplicate(div(String.length(message),String.length(keyword))+1) |> to_charlist()
    message = message
    |> String.downcase() |> to_charlist()

    Enum.zip_with(message, keyword, fn(i,j) ->
      {_ , i_index} = List.keyfind!(alphabet(),i,0)
      {_ , j_index} = List.keyfind!(alphabet(),j,0)
      cond do
        i_index + j_index >= length(alphabet()) ->
          {letra, _}= List.keyfind(alphabet(), i_index + j_index - length(alphabet()), 1)
          letra
        true -> {letra, _} = List.keyfind(alphabet(), i_index + j_index, 1)
        letra
      end
    end)
     |> to_string()
  end

  def decode(keyword, message) do
    keyword = keyword
    |> String.downcase() |> String.duplicate(div(String.length(message),String.length(keyword))+1) |> to_charlist()
    message = message
    |> String.downcase() |> to_charlist()
    Enum.zip_with(message, keyword, fn(i,j) ->
      {_ , i_index} = List.keyfind!(alphabet(),i,0)
      {_ , j_index} = List.keyfind!(alphabet(),j,0)
      cond do
        i_index - j_index < 0 -> {letra, _}= List.keyfind(alphabet(), i_index + length(alphabet()) - j_index, 1)
        letra
        true ->
          {letra, _} = List.keyfind(alphabet(), i_index - j_index, 1)
          letra
      end
    end)
    |> to_string()
  end

  def decipher(cipher, message) do
    x = cipher
    |> String.downcase()  |> to_charlist()
    mensaje_codi = message
    |> String.downcase() |> to_charlist()
    Enum.zip_with(mensaje_codi, x, fn(i,n) ->
      {_ , i_index} = List.keyfind!(alphabet(),i,0)
      {_ , n_index} = List.keyfind!(alphabet(),n,0)
      cond do
        n_index - i_index < 0 -> {letra, _}= List.keyfind(alphabet(), n_index + length(alphabet()) - i_index, 1)
        letra
        true -> {letra, _} = List.keyfind(alphabet(), n_index - i_index, 1)
        letra
      end
    end)
    |> Enum.reduce("", fn(x,acumulador)->
      cond do
        String.length(acumulador) == 0 -> acumulador <> to_string([x])
        encode(acumulador, message) == cipher -> acumulador
        true -> acumulador <> to_string([x])
      end
    end)
  end
end
