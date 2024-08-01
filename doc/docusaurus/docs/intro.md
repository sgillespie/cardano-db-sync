---
sidebar_position: 1
slug: /
---

# Introduction

**Note:** Anyone wishing to build and run anything in this repository should avoid the `master` branch and build/run from the latest release tag.

## Purpose

The purpose of Cardano DB Sync is to follow the Cardano chain and take information from the chain
and an internally maintained copy of ledger state. Data is then extracted from the chain and
inserted into a PostgreSQL database. SQL queries can then be written directly against the database
schema or as queries embedded in any language with libraries for interacting with an SQL database.

Examples of what someone would be able to do via an SQL query against a Cardano DB Sync
instance fully synced to a specific network is:

* Look up any block, transaction, address, stake pool etc on that network, usually by the hash that
  identifies that item or the index into another table.
* Look up the balance of any stake address for any Shelley or later epoch.
* Look up the amount of ADA delegated to each pool for any Shelley or later epoch.

Example SQL queries are available at [Example Queries][ExampleQueries]. You can also find some [DB Sync best practices here](https://docs.cardano.org/cardano-components/cardano-db-sync/best-practices).

## System Requirements

The system requirements for `cardano-db-sync` (with both `db-sync` and the `node` running
on the same machine are:

* Any of the big well known Linux distributions (eg, Debian, Ubuntu, RHEL, CentOS, Arch
  etc).
* 32 Gigabytes of RAM or more.
* 4 CPU cores or more.
* Ensure that the machine has sufficient IOPS (Input/Output Operations per Second). Ie it should be
  60k IOPS or better. Lower IOPS ratings will result in slower sync times and/or falling behind the
  chain tip.
* 320 Gigabytes or more of disk storage (preferably SSD which are 2-5 times faster than
  electro-mechanical disks).

The recommended configuration is to have the `db-sync` and the PostgreSQL server on the same
machine. During syncing (getting historical data from the blockchain) there is a **HUGE** amount
of data traffic between `db-sync` and the database. Traffic to a local database is significantly
faster than traffic to a database on the LAN or remotely to another location.

When building an application that will be querying the database, remember that for fast queries,
low latency disk access is far more important than high throughput (assuming the minimal IOPS
above is met).

## How to Contact the Cardano DB Sync Team

You can discuss development or find help at the following places:

 * Intersect Discord [#db-sync](https://discord.com/channels/1136727663583698984/1239888910537064468) channel, if new to server invite [here](https://discord.gg/GXrTvmzHQN)
 * [GitHub Issues](https://github.com/IntersectMBO/cardano-db-sync/issues)
