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
# The following MIBs are checked
# sysGlobalTmmStatClientBytesOut
# sysGlobalTmmStatClientPktsOut
# sysGlobalTmmStatClientBytesIn
# sysGlobalTmmStatClientPktsIn
# sysGlobalTmmStatClientCurConns
# sysGlobalTmmStatClientMaxConns
# sysGlobalTmmStatClientTotConns
# sysGlobalTmmStatServerBytesOut
# sysGlobalTmmStatServerPktsOut
# sysGlobalTmmStatServerBytesIn
# sysGlobalTmmStatServerPktsIn
# sysGlobalTmmStatServerCurConns
# sysGlobalTmmStatServerMaxConns
# sysGlobalTmmStatServerTotConns
# sysGlobalTmmStatMemoryUsed
# sysGlobalTmmStatDroppedPackets
# sysGlobalTmmStatIncomingPacketErrors
# sysGlobalTmmStatOutgoingPacketErrors
# sysGlobalTmmStatHttpRequests

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
      '1.3.6.1.4.1.3375.2.1.1.2.21.6.0' => 'tmm.client.bytes.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.4.0' => 'tmm.client.bytes.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.5.0' => 'tmm.client.packets.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.3.0' => 'tmm.client.packets.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.7.0' => 'tmm.client.conns.max',
      '1.3.6.1.4.1.3375.2.1.1.2.21.8.0' => 'tmm.client.conns.current',
      '1.3.6.1.4.1.3375.2.1.1.2.21.9.0' => 'tmm.client.conns.total',
      '1.3.6.1.4.1.3375.2.1.1.2.21.10.0' => 'tmm.server.packets.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.11.0' => 'tmm.server.bytes.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.12.0' => 'tmm.server.packets.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.13.0' => 'tmm.server.bytes.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.14.0' => 'tmm.server.conns.max',
      '1.3.6.1.4.1.3375.2.1.1.2.21.15.0' => 'tmm.server.conns.total',
      '1.3.6.1.4.1.3375.2.1.1.2.21.16.0' => 'tmm.server.conns.current',
      '1.3.6.1.4.1.3375.2.1.1.2.21.28.0' => 'tmm.memory.total',
      '1.3.6.1.4.1.3375.2.1.1.2.21.29.0' => 'tmm.memory.used'
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
              index.each do |vba|
                if config[:prefix]
                  output "#{config[:prefix]}.#{host}.#{suffix}.#{counter}", vba.value.to_s
                else
                  output "#{host}.#{suffix}", vba.value.to_s
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
