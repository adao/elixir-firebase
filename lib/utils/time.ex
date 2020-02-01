defmodule Utils.Time do
  def unix_epoch_in_seconds do
    {mega, sec, _micro} = :erlang.now
    mega * 1_000_000 + sec
  end
end
