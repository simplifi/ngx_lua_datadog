local dogstatsd_mt = {}
dogstatsd_mt.__index = dogstatsd_mt

function dogstatsd_mt:new(conf)
  local sock = ngx.socket.udp()
  sock:settimeout(conf.timeout)
  local _, err = sock:setpeername(conf.host, conf.port)
  if err then
    return nil, "failed to connect to "..conf.host..":"..tostring(conf.port)..": "..err
  end
  
  local dogstatsd = {
    host = conf.host,
    port = conf.port,
    socket = sock,
    namespace = conf.namespace
  }
  return setmetatable(dogstatsd, dogstatsd_mt)
end

function dogstatsd_mt:create_dogstatsd_message(stat, delta, kind, sample_rate, tags)
  local rate = ""
  if sample_rate and sample_rate ~= 1 then 
    rate = "|@"..sample_rate 
  end
  
  local tag_string = ""
  if tags then
    tag_string = "|#"..tags
  end

  local message = {
    self.namespace,
    ".",
    stat,
    ":",
    delta,
    "|",
    kind,
    rate,
    tag_string
  }
  return table.concat(message, "")
end

function dogstatsd_mt:close_socket()
  local ok, err = self.socket:close()
  if not ok then
    ngx.log(ngx.ERR, "failed to close connection from "..self.host..":"..tostring(self.port)..": ", err)
    return
  end
end

function dogstatsd_mt:send_dogstatsd(stat, delta, kind, sample_rate, tags)
  local udp_message = self:create_dogstatsd_message(stat, delta, kind, sample_rate, tags)
  local ok, err = self.socket:send(udp_message)
  if not ok then
    ngx.log(ngx.ERR, "failed to send data to "..self.host..":"..tostring(self.port)..": ", err)
  end
end

function dogstatsd_mt:gauge(stat, value, sample_rate, tags)
  return self:send_dogstatsd(stat, value, "g", sample_rate, tags)
end

function dogstatsd_mt:counter(stat, value, sample_rate, tags)
  return self:send_dogstatsd(stat, value, "c", sample_rate, tags)
end

function dogstatsd_mt:timer(stat, ms, tags)
  return self:send_dogstatsd(stat, ms, "ms", nil, tags)
end

function dogstatsd_mt:histogram(stat, value, tags)
  return self:send_dogstatsd(stat, value, "h", nil, tags)
end

function dogstatsd_mt:meter(stat, value, tags)
  return self:send_dogstatsd(stat, value, "m", nil, tags)
end

function dogstatsd_mt:set(stat, value, tags)
  return self:send_dogstatsd(stat, value, "s", nil, tags)
end

return dogstatsd_mt

