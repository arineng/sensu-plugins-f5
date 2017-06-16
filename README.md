## sensu-plugins-f5

[![Build Status](https://travis-ci.org/smbambling/sensu-plugins-f5.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-f5)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-f5.svg)](http://badge.fury.io/rb/sensu-plugins-f5)
[![Code Climate](https://codeclimate.com/github/arineng/sensu-plugins-f5/badges/gpa.svg)](https://codeclimate.com/github/arineng/sensu-plugins-f5)
[![Test Coverage](https://codeclimate.com/github/arineng/sensu-plugins-f5/badges/coverage.svg)](https://codeclimate.com/github/arineng/sensu-plugins-f5)
[![Dependency Status](https://gemnasium.com/arineng/sensu-plugins-f5.svg)](https://gemnasium.com/arineng/sensu-plugins-f5)

## Functionality

**check-f5-load.rb**
Checks the reported SNMP system load for an F5 load balancer

**check-f5-mem-pcnt.rb**
Checks the reported SNMP memory usage percentage for an F5 load balancer

**metrics-f5.rb**
Collects Metrics via SNMP for F5 devices

| Name                                 | OID                               | Description                                                                                                                                                                         |   |   |   |   |
|--------------------------------------|-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|---|---|---|
| sysStatMemoryTotald                  | .1.3.6.1.4.1.3375.2.1.1.2.1.44    | The total host memory in bytes for the system                                                                                                                                       |   |   |   |   |
| sysStatMemoryUsed                    | .1.3.6.1.4.1.3375.2.1.1.2.1.45    | The memory in use in bytes for TMM (Traffic Management Module)                                                                                                                      |   |   |   |   |
| sysGlobalHostMemTotal                | .1.3.6.1.4.1.3375.2.1.1.2.20.2    | The total host memory in bytes for the system                                                                                                                                       |   |   |   |   |
| sysGlobalHostMemUsed                 | .1.3.6.1.4.1.3375.2.1.1.2.20.3    | The host memory in bytes currently in use for the system                                                                                                                            |   |   |   |   |
| sysGlobalHostSwapTotal               | .1.3.6.1.4.1.3375.2.1.1.2.20.46   | The total swap in bytes for the system                                                                                                                                              |   |   |   |   |
| sysGlobalHostSwapUsed                | .1.3.6.1.4.1.3375.2.1.1.2.20.46.0 | The swap in bytes currently in use for the system                                                                                                                                   |   |   |   |   |
| sysMultiHostCpuUsageRatio            | .1.3.6.1.4.1.3375.2.1.7.5.2.1.11  | This is usage ratio of CPU for the associated host. This value indicates the present cpu usage. For usage computed over specific intervals, please use the specific (5s,1m,5m) OIDs |   |   |   |   |
| sysGlobalHostCpuUsageRatio           | .1.3.6.1.4.1.3375.2.1.1.2.20.13   | This is usage ratio of CPU for the system. It is calculated by (sum of deltas for user, niced, system)/(sum of deltas of user, niced, system, idle, irq, softirq, andiowait)        |   |   |   |   |
| sysGlobalHostCpuUser                 | .1.3.6.1.4.1.3375.2.1.1.2.20.6    | The average time spent by all processors in user context for the system                                                                                                             |   |   |   |   |
| sysGlobalHostCpuNice                 | .1.3.6.1.4.1.3375.2.1.1.2.20.7    | The average time spent by all processors running niced processes for the system                                                                                                     |   |   |   |   |
| sysGlobalHostCpuSystem               | .1.3.6.1.4.1.3375.2.1.1.2.20.8    | The average time spent by all processors servicing system calls for the system                                                                                                      |   |   |   |   |
| sysGlobalHostCpuIdle                 | .1.3.6.1.4.1.3375.2.1.1.2.20.9    | The average time spent by all processors doing nothing for the system                                                                                                               |   |   |   |   |
| sysGlobalHostCpuIrq                  | .1.3.6.1.4.1.3375.2.1.1.2.20.10   | The average time spent by all processors servicing hardware interrupts for the system                                                                                               |   |   |   |   |
| sysGlobalHostCpuSoftirq              | .1.3.6.1.4.1.3375.2.1.1.2.20.11   | The average time spent by all processors servicing soft interrupts for the system                                                                                                   |   |   |   |   |
| sysGlobalHostCpuIowait               | .1.3.6.1.4.1.3375.2.1.1.2.20.12   | The average time spent by all processors waiting for external I/O to complete for the system                                                                                        |   |   |   |   |
| sysGlobalHostCpuStolen               | .1.3.6.1.4.1.3375.2.1.1.2.20.38   | The time 'stolen' from the system (for virtual machines)                                                                                                                            |   |   |   |   |
| sysGlobalTmmStatClientBytesIn        | .1.3.6.1.4.1.3375.2.1.1.2.21.4    | The number of bytes received by the system from client-side                                                                                                                         |   |   |   |   |
| sysGlobalTmmStatClientBytesOut       | .1.3.6.1.4.1.3375.2.1.1.2.21.6    | The number of bytes sent to client-side from the system                                                                                                                             |   |   |   |   |
| sysGlobalTmmStatClientCurConns       | .1.3.6.1.4.1.3375.2.1.1.2.21.9    | The current connections from client-side to the system                                                                                                                              |   |   |   |   |
| sysGlobalTmmStatClientTotConns       | .1.3.6.1.4.1.3375.2.1.1.2.21.8    | The total connections from client-side to the system                                                                                                                                |   |   |   |   |
| sysGlobalTmmStatHttpRequests         | .1.3.6.1.4.1.3375.2.1.1.2.21.33   | The total number of HTTP requests to the system                                                                                                                                     |   |   |   |   |
| sysGlobalTmmStatMemoryTotal          | .1.3.6.1.4.1.3375.2.1.1.2.21.28   | The total memory available in bytes for TMM (Traffic Management Module)                                                                                                             |   |   |   |   |
| sysGlobalTmmStatMemoryUsed           | .1.3.6.1.4.1.3375.2.1.1.2.21.29   | The memory in use in bytes for TMM (Traffic Management Module)                                                                                                                      |   |   |   |   |
| sysGlobalTmmStatServerBytesIn        | .1.3.6.1.4.1.3375.2.1.1.2.21.11   | The number of bytes received by the system from server-side                                                                                                                         |   |   |   |   |
| sysGlobalTmmStatServerBytesOut       | .1.3.6.1.4.1.3375.2.1.1.2.21.13   | The number of bytes sent to server-side from the system                                                                                                                             |   |   |   |   |
| sysGlobalTmmStatServerCurConns       | .1.3.6.1.4.1.3375.2.1.1.2.21.16   | The current connections from server-side to the system                                                                                                                              |   |   |   |   |
| sysGlobalTmmStatServerTotConns       | .1.3.6.1.4.1.3375.2.1.1.2.21.15   | The total connections from server-side to the system                                                                                                                                |   |   |   |   |
| sysGlobalTmmStatTmUsageRatio1m       | .1.3.6.1.4.1.3375.2.1.1.2.21.35   | The percentage of time all TMMs were busy over the last 1 minute                                                                                                                    |   |   |   |   |
| sysGlobalTmmStatTmUsageRatio5m       | .1.3.6.1.4.1.3375.2.1.1.2.21.36   | The percentage of time all TMMs were busy over the last 1 minute                                                                                                                    |   |   |   |   |
| sysGlobalTmmStatTmUsageRatio5s       | .1.3.6.1.4.1.3375.2.1.1.2.21.34   | The percentage of time all TMMs were busy over the last 5 seconds                                                                                                                   |   |   |   |   |
| sysConnPoolStatConnects              | .1.3.6.1.4.1.3375.2.1.1.2.3.5     | The number of connections established                                                                                                                                               |   |   |   |   |
| sysConnPoolStatCurSize               | .1.3.6.1.4.1.3375.2.1.1.2.3.2     | The number of currently idle connections in pools on the system                                                                                                                     |   |   |   |   |
| sysConnPoolStatMaxSize               | .1.3.6.1.4.1.3375.2.1.1.2.3.3     | The number of idle connections in pools on the system                                                                                                                               |   |   |   |   |
| sysConnPoolStatReuses                | .1.3.6.1.4.1.3375.2.1.1.2.3.4     | The number of times a connection was reused from pools on the system                                                                                                                |   |   |   |   |
| sysGlobalTmmStatClientPktsOut        | .1.3.6.1.4.1.3375.2.1.1.2.21.5    | The number of packets sent to client-side from the system                                                                                                                           |   |   |   |   |
| sysGlobalTmmStatClientPktsIn         | .1.3.6.1.4.1.3375.2.1.1.2.21.3    | The number of packets received by the system from client-side                                                                                                                       |   |   |   |   |
| sysGlobalTmmStatClientMaxConns       | .1.3.6.1.4.1.3375.2.1.1.2.21.7    | The maximum connections from client-side to the system                                                                                                                              |   |   |   |   |
| sysGlobalTmmStatServerPktsOut        | .1.3.6.1.4.1.3375.2.1.1.2.21.12   | The number of packets sent to server-side from the system                                                                                                                           |   |   |   |   |
| sysGlobalTmmStatServerPktsIn         | .1.3.6.1.4.1.3375.2.1.1.2.21.10   | The number of packets received by the system from server-side                                                                                                                       |   |   |   |   |
| sysGlobalTmmStatServerMaxConns       | .1.3.6.1.4.1.3375.2.1.1.2.21.14   | The maximum connections from server-side to the system                                                                                                                              |   |   |   |   |
| sysGlobalTmmStatDroppedPackets       | .1.3.6.1.4.1.3375.2.1.1.2.21.30   | The total dropped packets                                                                                                                                                           |   |   |   |   |
| sysGlobalTmmStatIncomingPacketErrors | .1.3.6.1.4.1.3375.2.1.1.2.21.31   | The total incoming packet errors for the system                                                                                                                                     |   |   |   |   |
| sysGlobalTmmStatOutgoingPacketErrors | .1.3.6.1.4.1.3375.2.1.1.2.21.32   | The total outgoing packet errors for the system                                                                                                                                     |   |   |   |   |

## Files
 * check-f5-load.rb
 * check-f5-mem-pcnt.rb
 * metrics-f5.rb

## Usage

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)
