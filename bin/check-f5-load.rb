#!/usr/bin/env ruby
# F5 BigIP Load Check
# ===
#
# Checks the reported SNMP system load for F5 BigIP
# load balancer
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: snmp
#
# USAGE:
#
#   check-f5-load  -h host -C community -p prefix
#

require 'sensu-plugin/check/cli'
require 'snmp'

class CheckF5Load < Sensu::Plugin::Check::CLI
  option :host,
         short: '-h host',
         boolean: true,
         default: '127.0.0.1',
         required: true

  option :community,
         short: '-C snmp community',
         boolean: true,
         default: 'public'

  option :snmp_version,
         short: '-v version',
         description: 'SNMP version to use (SNMPv1, SNMPv2c (default))',
         default: 'SNMPv2c'

  option :warn,
         description: 'Warning load average threshold',
         short: '-w VALUE',
         long: '--warning VALUE',
         default: '90',
         required: true

  option :crit,
         description: 'Critical load average threshold',
         short: '-c VALUE',
         long: '--critical VALUE',
         default: '95',
         required: true

  def run
    per_cpu_usage_mib = '1.3.6.1.4.1.3375.2.1.7.5.2.1.11'
    total_cpu_usage = 0
    total_cpu_count = 0
    begin
      manager = SNMP::Manager.new(host: config[:host].to_s, community: config[:community].to_s, version: config[:snmp_version].to_sym)
      manager.walk([per_cpu_usage_mib.to_s]) do |usage|
        total_cpu_count += 1
        usage.each do |per_cpu_usage|
          total_cpu_usage += per_cpu_usage.value.to_i
        end
      end
    rescue SNMP::RequestTimeout
      unknown "#{config[:host]} not responding"
    rescue => e
      unknown "An unknown error occured: #{e.inspect}"
    end
    manager.close

    cpu_usage_avg = total_cpu_usage / total_cpu_count
    if cpu_usage_avg >= config[:crit].to_f
      critical "Load average #{cpu_usage_avg}"
    elsif cpu_usage_avg >= config[:warn].to_f
      warning "Load average #{cpu_usage_avg}"
    else
      ok "Load average #{cpu_usage_avg}"
    end
  end
end
