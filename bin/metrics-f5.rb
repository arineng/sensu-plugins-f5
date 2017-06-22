#!/usr/bin/env ruby
# F5 Device
# ===
#
# Collects Metrics via SNMP for a F5 PBX
#   - Sucscription Days Left
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: snmp
#
# USAGE:
#
#   metric.f5 -h host -C community -p prefix
#
require 'sensu-plugin/metric/cli'
require 'snmp'

# Class that collects and outputs SNMP metrics in graphite format
class MetricsF5 < Sensu::Plugin::Metric::CLI::Graphite
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
      '1.3.6.1.4.1.3375.2.1.1.2.1.44' => 'tmm.mem.total',
      '1.3.6.1.4.1.3375.2.1.1.2.1.45' => 'tmm.mem.used',
      '1.3.6.1.4.1.3375.2.1.1.2.20.2' => 'host.mem.total',
      '1.3.6.1.4.1.3375.2.1.1.2.20.3' => 'host.mem.used',
      '1.3.6.1.4.1.3375.2.1.1.2.20.46' => 'host.swap.total',
      '1.3.6.1.4.1.3375.2.1.1.2.20.47' => 'host.swap.used',
      '1.3.6.1.4.1.3375.2.1.7.5.2.1.11' => 'multihost.cpu.load',
      '1.3.6.1.4.1.3375.2.1.1.2.20.13' => 'global.host.cpu.load',
      '1.3.6.1.4.1.3375.2.1.1.2.20.6' => 'global.host.cpu.user',
      '1.3.6.1.4.1.3375.2.1.1.2.20.7' => 'global.host.cpu.nice',
      '1.3.6.1.4.1.3375.2.1.1.2.20.8' => 'global.host.cpu.system',
      '1.3.6.1.4.1.3375.2.1.1.2.20.9' => 'global.host.cpu.idle',
      '1.3.6.1.4.1.3375.2.1.1.2.20.10' => 'global.host.cpu.irq',
      '1.3.6.1.4.1.3375.2.1.1.2.20.11' => 'global.host.cpu.softirq',
      '1.3.6.1.4.1.3375.2.1.1.2.20.12' => 'global.host.cpu.iowait',
      '1.3.6.1.4.1.3375.2.1.1.2.20.38' => 'global.host.cpu.stolen',
      '1.3.6.1.4.1.3375.2.1.1.2.21.4' => 'global.tmm.client.bytes.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.6' => 'global.tmm.client.bytes.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.9' => 'global.tmm.client.current.conns',
      '1.3.6.1.4.1.3375.2.1.1.2.21.8' => 'global.tmm.client.total.conns',
      '1.3.6.1.4.1.3375.2.1.1.2.21.33' => 'global.tmm.http.requests',
      '1.3.6.1.4.1.3375.2.1.1.2.21.28' => 'global.tmm.mem.total',
      '1.3.6.1.4.1.3375.2.1.1.2.21.29' => 'global.tmm.mem.used',
      '1.3.6.1.4.1.3375.2.1.1.2.21.11' => 'global.tmm.server.bytes.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.13' => 'global.tmm.server.bytes.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.16' => 'global.tmm.server.current.conns',
      '1.3.6.1.4.1.3375.2.1.1.2.21.15' => 'global.tmm.server.total.conns',
      '1.3.6.1.4.1.3375.2.1.1.2.21.35' => 'global.tmm.usage.ratio.1m',
      '1.3.6.1.4.1.3375.2.1.1.2.21.36' => 'global.tmm.usage.ratio.5m',
      '1.3.6.1.4.1.3375.2.1.1.2.21.34' => 'global.tmm.usage.ratio.5s',
      '1.3.6.1.4.1.3375.2.1.1.2.3.5' => 'pool.connections',
      '1.3.6.1.4.1.3375.2.1.1.2.3.2' => 'pool.current.size',
      '1.3.6.1.4.1.3375.2.1.1.2.3.3' => 'pool.max.size',
      '1.3.6.1.4.1.3375.2.1.1.2.3.4' => 'pool.reuses',
      '1.3.6.1.4.1.3375.2.1.1.2.21.5' => 'global.tmm.client.pkts.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.3' => 'global.tmm.client.pkts.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.7' => 'global.tmm.client.max.conns',
      '1.3.6.1.4.1.3375.2.1.1.2.21.12' => 'global.tmm.server.pkts.out',
      '1.3.6.1.4.1.3375.2.1.1.2.21.10' => 'global.tmm.server.pkts.in',
      '1.3.6.1.4.1.3375.2.1.1.2.21.14' => 'global.tmm.server.max.conns',
      '1.3.6.1.4.1.3375.2.1.1.2.21.30' => 'global.tmm.dropped.packets',
      '1.3.6.1.4.1.3375.2.1.1.2.21.31' => 'global.tmm.incoming.packet.errors',
      '1.3.6.1.4.1.3375.2.1.1.2.21.32' => 'global.tmm.outgoing.packet.errors'
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
        manager.get([objectid.to_s]).each_varbind do |vbg|
          if vbg.value.to_s !~ /noSuchInstance/
            if config[:prefix]
              output "#{config[:prefix]}.#{host}.#{suffix}", vbg.value.to_s
            else
              output "#{host}.#{suffix}", vbg.value.to_s
            end
          else
            counter = 0
            manager.walk([objectid.to_s]) do |index|
              counter += 1
              index.each do |vbw|
                if config[:prefix]
                  output "#{config[:prefix]}.#{host}.#{suffix}.#{counter}", vbw.value.to_s
                else
                  output "#{host}.#{suffix}", vbw.value.to_s
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
