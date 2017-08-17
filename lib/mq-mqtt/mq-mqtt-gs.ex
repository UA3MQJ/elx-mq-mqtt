defmodule MQMQTT.Gs do
  @moduledoc """
  GS module wrapper on hulaaki client
  translate callback method to message method
  """

  use GenServer
  use Hulaaki.Client
  require Logger

  def start_link() do

    {:ok, hulaaki_client_pid} = start_link(%{})
    Logger.debug ">>>> hulaaki_client_pid=#{inspect hulaaki_client_pid}"

    config = mqtt_config()
    client_id = inspect(make_ref())
    options = [client_id: client_id, host: config.host, port: config.port]
    state = %{parent_pid: self(),
                hulaaki_client_pid: hulaaki_client_pid,
                options: options}

    GenServer.start_link(__MODULE__, [state])
  end

  def init([state]) do
    {:ok, state}
  end

  def connect(pid) do
    Logger.debug ">>>> MQMQTT.Gs connect pid=#{inspect pid}   self()=#{inspect self()}"
    GenServer.call(pid, :connect)
  end


  def handle_call(:connect, from, state) do
    Logger.debug ">>>> MQMQTT.Gs handle_call :connect from=#{inspect from} state=#{inspect state}  self()=#{inspect self()}"

    result = connect(state.hulaaki_client_pid, state.options)

    {:reply, result, state}
  end

  # callbcks for hulaaki client
  def on_connect(info) do
    Logger.debug ">>>>>>> mqmqtt.gs callback on_connect info=#{inspect info}    self()=#{inspect self()}"

  end

  # read MQTT parameters from config/config.exs
  defp mqtt_config() do
    config = Application.get_env(:mqmqtt, :mqmqtt, %{})

    unless is_bitstring(config.host) do
      raise({:bad_host, config.host})
    end

    unless is_integer(config.port) do
      raise({:bad_port, config.port})
    end
    
    config
  end
end
