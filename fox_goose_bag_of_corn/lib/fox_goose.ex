defmodule FoxGoose do
  @listaRestricciones [[:fox, :goose],[:corn, :goose]]
  @final [[], [:boat], [:corn, :fox, :goose, :you]]

  def solver(listaActual) do
    #nos dice donde esta el :you
    posi= Enum.find_index(listaActual, &(Enum.member?(&1, :you)))
    case posi do
      #regresa los posibles elementos a mover
      0 -> Enum.at(listaActual,0)
        #concatenar el elemento a lista del bote
        |> Enum.map(fn x ->
          #mueve el :you y un elemento al :bote
          List.update_at(listaActual,1,&(&1++[x,:you]))
          #elimina el elemento que se movio de la lista de la orilla
          |>List.update_at(0,&List.delete(&1,x))
          |>List.update_at(0,&List.delete(&1,:you))
          |>Enum.map(&Enum.uniq(&1))
        end)

      1 -> elem_en_bote = Enum.at(listaActual,1) |> List.delete(:boat)
       listaActual = List.update_at(listaActual,1,&(&1=[:boat]))
       [List.update_at(listaActual,0, &(&1++elem_en_bote)),List.update_at(listaActual,2, &(&1++elem_en_bote))]

     2 ->  Enum.at(listaActual,2)
       #concatenar el elemento a lista del bote
       |> Enum.map(fn x ->
         List.update_at(listaActual,1,&(&1++[x,:you]))
         |>List.update_at(2,&List.delete(&1,x))
         |>List.update_at(2,&List.delete(&1,:you))
         |>Enum.map(&Enum.uniq(&1))
       end)
    end
  end

  def verificacion(listaPrincipal) do 
    #IO.inspect(listaPrincipal)
    #Busca estados restringidos de los cuales retorna una lista de listas con booleanos
    #regresa un booleano (si es correcto = false)
    Enum.any?(listaPrincipal, fn x -> Enum.any?(@listaRestricciones, &(&1 == x) )end)
  end

  def arbol(caminos_pos) do
    case Enum.filter(caminos_pos, &(List.last(&1) == @final)) do
      [] ->
        caminos_pos = for camino_pos <- caminos_pos, paso_sig <- solver(List.last(camino_pos)) do
          camino_pos = Enum.map(camino_pos, fn x-> Enum.map(x, &Enum.sort(&1)) end)
          paso_sig = Enum.map(paso_sig, &Enum.sort(&1))
          case (verificacion(paso_sig) or Enum.member?(camino_pos, paso_sig)) do
            false  -> camino_pos ++ [paso_sig]
            true   -> nil
          end
        end
        Enum.uniq(caminos_pos)
        |> List.delete(nil)
        |> arbol()
      _ -> caminos_pos |> Enum.filter(&(List.last(&1) == @final))
    end
  end

  def init() do
    arbol([[[[:corn, :fox, :goose, :you], [:boat], []]]])
  end
end  
