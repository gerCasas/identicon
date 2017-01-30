defmodule Identicon do
  @moduledoc """
    Genera un identicon por un nombre de usuario de parametro
  """

  @doc """
    metodo principal, ejecuta los demas metodos: hash_input
  """
  def main(input) do
    input
    |> hash_input
  end

  @doc """
    Transforma el input string en hash y despues a lista. Para que siempre que se ingrese el mismo string siempre sea el mismo resultado de lista.
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end



end
