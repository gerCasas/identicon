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
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Función para guardar en disco la imagen renderiada por el metodo :egd.reder(). El primer parametro es la imagen y el segundo parametro es el nombre con el que se guardara la imagen, este parametro es el mismo con el que se mando a llamar el método main.
  """
  def save_image(image, input) do
    # para agregar una variable a un string ..
    # la variable se encapsula en #{}
    File.write("#{input}.png", image)
  end

  @doc """
    Conforme al color y pixel_map con :egd se crea la imagen y se le hace render. Los metodos de :egd no regresan una nueva imagen si no que la imagen que mandas como parametro es modificada directamente y por lo tanto los resultados de estos metodos no se tienen que igualar a image.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
    Conforme al grid, con Enum.map se calculan las posiciones X y Y de cada elemento. El resultado es guardado dento del campo de la estructura pixel_map.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left,bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """

    Toma el grid y solo regresa los elementos pares con rem(code, 2). Se puede poner la sintaxis con una solo linea como se muestra en el ejemplo, o se pueden omitir los primeros parentesis.

  ## Examples

      iex> grid = Enum.filter(grid, fn({code, _index}) -> rem(code, 2) == 0 end)

      iex> grid = Enum.filter grid, fn({code, _index}) ->
        rem(code, 2) == 0
      end

  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: grid}
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
    # [1, 2, 3] - input
    [first, second | _tail] = row

    # [1, 2, 3, 2, 1] - output
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
