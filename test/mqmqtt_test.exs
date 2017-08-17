defmodule MQMQTTTest do

  require Logger
  use ExUnit.Case
  #use MQMQTT

  # use Hulaaki.Client

  # def on_connect_ack(options) do
  #   Logger.debug ">>>>>>> on_connect_ack options=#{inspect options}"
  # end

  # def on_subscribed_publish(options) do
  #   Logger.debug ">>>>>>> on_subscribed_publish options=#{inspect options}"
  # end

  # def on_subscribe_ack(options) do
  #   Logger.debug ">>>>>>> on_subscribe_ack options=#{inspect options}"
  # end

  # def on_pong(options) do
  #   Logger.debug ">>>>>>> on_pong options=#{inspect options}"
  # end

  # def on_unsubscribe(options) do
  #   Logger.debug ">>>>>>> on_pong options=#{inspect options}"
  # end

  # def on_subscribed_publish(options) do
  #   Logger.debug ">>>>>>> on_subscribed_publish options=#{inspect options}"
  # end

  # test "create" do
  #   {:ok, pid} = __MODULE__.start_link(%{})

  #   Logger.debug ">>>>>>> pid=#{inspect pid}"

  #   client_id = inspect(make_ref)
  #   options = [client_id: client_id, host: "localhost", port: 1883]
  #   Logger.debug ">>>>>>> options=#{inspect options}"

  #   __MODULE__.connect(pid, options)

  #   __MODULE__.ping(pid)

  #   options = [id: 24_756, topics: ["event"], qoses: [0]]
  #   __MODULE__.subscribe(pid, options)

  #   options = [id: 24_756, topic: "event", message: "a message from elixir client",
  #              dup: 0, qos: 0, retain: 0]
  #   __MODULE__.publish(pid, options)



  #   :timer.sleep(5000)
  # end

  test "create" do
    Process.register(self(), :mq_mqtt_tester)

    Logger.debug ">>>>>>> test module pid =#{inspect self()}"

    {:ok, pid} = MQMQTT.Gs.start_link()
    Logger.debug ">>>>>>> MQMQTT.Gs pid=#{inspect pid}"

    result = MQMQTT.Gs.connect(pid)

    Logger.debug ">>>>>>> connect result=#{inspect result} self()=#{inspect self()}"
    
    :timer.sleep(1000)

    # {:ok, pid} = start_link()
    # Logger.debug ">>>>>>> start_link pid=#{inspect pid} self()=#{inspect self()}"
   
    # assert {:ok, ref} = connect(pid)
    # Logger.debug ">>>>>>> connect ref=#{inspect ref} self()=#{inspect self()}"

  #   assert {:ok, _ref}      = subscribe(pid, "event")

  #   assert :ok              = publish(pid, "event", "test event")
    
  #   receive do
  #     %{subject: subject, message: message} ->
  #       Logger.info "***** RCVD : subject = #{inspect subject} message = #{inspect message}"
  #       assert subject = "event"
  #       assert message = "test event"
  #     after
  #       2_000 ->
  #         Logger.info "***** RCVD - timeout"
  #         throw("msg not received")
  #   end

  #   assert res = unsubscribe(pid, "event")
  #   Logger.debug ">>>>>>> unsubscribe res=#{inspect res}"

    
  #   assert res = unsubscribe(pid, "event")
  #   Logger.debug ">>>>>>> unsubscribe res=#{inspect res}"

  #   assert :ok = disconnect(pid)

  end

  def on_connect(info) do
    Logger.debug ">>>>>>> MQMQTTTest CALLBACK on_connect info=#{inspect info}"
  end

  def on_disconnect() do
    Logger.debug ">>>>>>> CALLBACK on_disconnect"
  end

  def on_subscribe(info) do
    Logger.debug ">>>>>>> CALLBACK on_subscribe info=#{inspect info}"
  end

  def on_unsubscribe(info) do
    Logger.debug ">>>>>>> CALLBACK on_unsubscribe info=#{inspect info}"
  end

  def on_subscribed_publish(info) do
    Logger.debug ">>>>>>> CALLBACK on_subscribed_publish  info=#{inspect info}"
    case Process.whereis(:mq_mqtt_tester) do
      nil ->
        :ok # nothing to do
      pid ->
        send(pid, info)
      :ok
    end
  end
  
  def on_publish(info) do
    Logger.debug ">>>>>>> CALLBACK on_publish  info=#{inspect info}"
  end

end
