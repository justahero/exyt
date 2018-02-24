defmodule Exyt.Response do
  @moduledoc """
  Defines a Response struct which is created from a HTTP response.
  """

  @type status_code :: integer
  @type headers     :: list
  @type body        :: binary

  @type t :: %__MODULE__{
    status_code: status_code,
    headers:     headers,
    body:        body
  }

  defstruct status_code: nil,
            headers: [],
            body: nil

  @doc false
  def new(code, headers, body) do
    %__MODULE__{
      status_code: code,
      headers: headers,
      body: body
    }
  end
end
