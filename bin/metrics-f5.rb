#!/usr/bin/env ruby
# F5 Device
# ===
#
# Collects Metrics via SNMP for a Switchvox PBX
#   - Sucscription Days Left
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: snmp
#
# USAGE:
#
#   check-switchvox-pbx  -h host -C community -p prefix
#

require 'sensu-plugin/metric/cli'
require 'snmp'

# Class that collects and outputs SNMP metrics in graphite format
class MetricsSwitchvox < Sensu::Plugin::Metric::CLI::Graphite
  option :host,
         short: '-h host',
         boolean: true,
         default: '127.0.0.1',
         required: true

  option :community,
         short: '-C snmp community',
         boolean: true,
         default: 'public'

  option :prefix,
         short: '-p prefix',
         description: 'prefix to attach to graphite path',
         default: 'sensu'

  option :snmp_version,
         short: '-v version',
         description: 'SNMP version to use (SNMPv1, SNMPv2c (default))',
         default: 'SNMPv2c'

  option :graphite,
         short: '-g',
         description: 'Replace dots with underscores in hostname',
         boolean: true

  option :mibdir,
         short: '-d mibdir',
         description: 'Full path to custom MIB directory.'

  option :mibs,
         short: '-l mib[,mib,mib...]',
         description: 'Custom MIBs to load (from custom mib path).',
         default: ''

  def run
    metrics = {
      '1.3.6.1.4.1.3375.2.1.7.5.2.1.11' => 'cpu.load',
      '1.3.6.1.4.1.3375.2.1.1.2.1.45.0' => 'mem.used',
      '1.3.6.1.4.1.3375.2.1.1.2.1.44.0' => 'mem.total',
      '1.3.6.1.4.1.3375.2.1.1.2.20.47.0' => 'swap.used',
      '1.3.6.1.4.1.3375.2.1.1.2.20.46.0' => 'swap.total',
      '1.3.6.1.4.1.3375.2.1.1.2.9.2.0' => 'active.client.connections.ssl',
    }

    metrics.each do |objectid, suffix|
      mibs = config[:mibs].split(',')

      host = config[:host]
      host = config[:host].tr('.', '_') if config[:graphite]

      begin
        manager = SNMP::Manager.new(host: config[:host].to_s, community: config[:community].to_s, version: config[:snmp_version].to_sym)
        if config[:mibdir] && !mibs.empty?
          manager.load_modules(mibs, config[:mibdir])
        end
        manager.get([objectid.to_s]).each_varbind do |vb|
          if vb.value.to_s !~ /noSuchInstance/
            if config[:prefix]
              output "#{config[:prefix]}.#{host}.#{suffix}", vb.value.to_s
            else
              output "#{host}.#{suffix}", vb.value.to_s
            end
          else
            counter = 0 
            manager.walk([objectid.to_s]) do |index|
              counter += 1
              index.each do |vb|
                if config[:prefix]
                  output "#{config[:prefix]}.#{host}.#{suffix}.#{counter}", vb.value.to_s
                else
                  output "#{host}.#{suffix}", vb.value.to_s
                end
              end
            end
          end
        end

      rescue SNMP::RequestTimeout
        unknown "#{config[:host]} not responding"
      rescue => e
        unknown "An unknown error occured: #{e.inspect}"
      end

      manager.close
    end
    ok
  end
end
