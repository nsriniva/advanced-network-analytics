# neoplat - NEtwork Ops PLATform
# network-analytics
The aim of the Network Analytics framework is to be able to capture data from multiple sources and provide SQL and Graph query interfaces to the collected data. A  JavaScript/NodeJS analytics api will be used to perform the queries and further processing - this will allow the analytics modules to leverage the rich and powerful NodeJS ecosystem.

It will contain 4 major components -  Data Collection(DC), SQL Query(SQ), Graph Query(GQ) and Analytics engines:
DC Engine
---------
The DC engine will be extensible via plugins with initial support for (CDP, Process and Interface)MIBs, Syslog messages and SNMP notifications; where MIB data is retrieved _not_ via SNMP but file copy, using the [CISCO-BULK-FILE-MIB](http://www.cisco.com/c/en/us/support/docs/ip/simple-network-management-protocol-snmp/24304-bulk-file-mib.html) and the [Periodic MIB data collection and transfer mech](http://www.cisco.com/c/en/us/td/docs/ios/12_0s/feature/guide/gdatacol.html).
The MIB data capture will be implemented in Javascript/NodeJS using [node-mongodb/MongoDB](https://github.com/mongodb/node-mongodb-native) and [node-neo4j/Neo](https://github.com/thingdom/node-neo4j/tree/v2) - node-mongodb will push incoming data into MongoDB and node-neo4j will do the same for Neo.
Syslog capture will be implemented using SyslogNG configured to use the [MongoDB destination](https://www.balabit.com/sites/default/files/documents/syslog-ng-ose-latest-guides/en/syslog-ng-ose-guide-admin/html/configuring-destinations-mongodb.html).
SNMP notification capture will be implemented in Javascript/NodeJS and use node-mongodb to push data into MongoDB

SQ Engine
--------
The SQ engine will use [SlamData](http://slamdata.com/) to provide an SQL interface to  [MongoDB](https://www.mongodb.org/).

GQ Engine
---------
The GQ engine will use the [Cypher](http://neo4j.com/developer/cypher-query-language/) query language to interface with [Neo](https://github.com/neo4j/neo4j).

Analytics Engine
-------------
The analytics engine runs analytics modules in one or more NodeJS instances, where the modules are written using the analytics API which supports
* running SQL and Graph queries
* scheduling periodic querying
* setting up event based querying, where events would be changes to a table from any node, changes from a specific node to any table, changes to a specific node&table, ...

[
You could , for example, run
SELECT nodeId,ifDescr FROM interfaces WHERE utilization > 90 AND utilizationRate > 0

to identify the nodes, interfaces that are running hot and then use that information to run a graph query to identify  users/applications that could be impacted.
]

Proof of Concept
----------------
For the PoC we envisage the following:
* For SQL processing, there will be 5 tables that can be queried - neighbors, interfaces and processes, syslogs and notifications
* For the Graph queries
  * there will be 3 types of nodes - network(representing network elements), process and interface
  * network nodes will be connected to process  and interface nodes
  * interface nodes will connect to one network node and, optionally, to another interface node
  * network nodes will have name, cpu, mem, ver, ... properties
  * process nodes will have name, cpu, mem, ...  properties
  * interface nodes will have name, counters, state, ... properties
* The ability to get a graphical depiction of the network topology graph
