defmodule Identicon do
  @moduledoc """
    Genera un identicon por un nombre de usuario de parametro
  """

  @doc """
    metodo principal, ejecuta los demas metodos: hash_input, pick_color, build_grid
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
    Aplica Enum.chunk a la lista parametro.El resultado de Enum.chunk pasa por Enum.map y a cada row se le aplica la funcion mirror_row. Despues la Lista de listas se junta en una sola con List.flatten. Con Enum.with_index se le agrega el index a cada elemento de la lista.
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Metodo para hacer mirror de los primeros dos elementos de la lista. Entrada [1, 2, 3]. Salida [1, 2, 3, 2, 1].
  Con ++ se unen listas.
  """
  def mirror_row(row) do
    # [1, 2, 3]
    [first, second | _tail] = row

    # [1, 2, 3, 2, 1]
    row ++ [second, first]
  end

  @doc """
    Parametro de entrada estructura. Dentro de la estructura hay una lista con 16 elementos pero solo nos interesa los primeros 3 elementos ya que con esos 3 eligiremos el color, se utiliza pattern matching para obtener solo los primeros 3 elementos. El parametro image se puede procesar desde que se recibe (por eso se procesa desde que se recibe en la primera linea de codigo).
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # %Identicon.Image{hex: hex_list} = image
    # [r, g, b | _tail] = hex_list
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Transforma el input string en hash y despues a lista. Para que siempre que se ingrese el mismo string siempre sea el mismo resultado de lista. El resultado es guardado en la estructura Identicon.Image.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

end
