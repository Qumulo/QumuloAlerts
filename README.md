# QumuloAlerts

## Table of Contents

   * [Introduction](#introduction)
   * [Overview](#overview)
   * [QumuloAlerts Design](#qumuloalerts-design)
   * [Publisher](#publisher)
   * [Consumer](#consumer)
   * [Help](#help)
   * [Copyright](#copyright)
   * [License](#license)
   * [Trademarks](#trademarks)
   * [Contributors](#contributors)

## Introduction

Collect Alarms from the hardware and Alerts from the software of a Qumulo Cluster.

QumuloAlerts is an entire infrastructure, composed of plugins that provide the services.
This documentation will describe the infrastructure and what mechanisms we are using to facilitate communications
between the various parts and pieces.

The reader should think of this as a "living" design document in which I will outline my ideas
of how the system should work.

## Overview

Let's start with a picture of the the entire infrastructure.

![](Docs/QumuloAlerts.png)

## QumuloAlerts Design

QumuloAlerts is a set of docker containers that deals with alarms and alerts in a typical publisher / consumer model.
The publisher and each consumer run as individual containers that use a RabbitMQ queue for message delivery.

### Data Collected

All data is collected through individual plugins. There are three classifications of plugins; Alarms, Alerts, and Informational.

#### Alarms

Alarms are classified as hardware changes within a Qumulo cluster. The following list is just a sample of the Alarms collected. We may, in the future, collect more than listed below.

- Node Failure
- Disk Failure
- Power Supply Failure
- Fan Failure
- Network Interface Failure

#### Alerts

Alerts are classified as software or environmental changes within that same Qumulo cluster. The following list is just a sample of the Alerts collected. We may, in the future, add more alerts to those listed below.

- Quota Notification(s) - Done by configured percentage
- Snapshot Creation
- Snapshot Deletion
- Snapshot rate of change too high over a specified period of time (Used for RansomWare detection)
- Volume Notification - Done by configured percentage
- Replication Failure

#### Informational

Informational data is classified as any data on a Qumulo cluster that is not a hardware or software/environmental change.

Example data that is informational might be, but is not limited to:

- Throughput
- IOPS
- Latency
- Directory growth over a given period of time

### Exchanges and Queues

The heart of any publisher / consumer system is the queuing mechanism used. We have decided for a number
of reasons to use RabbitMQ.

Let's quickly go over basic message passing:

* A producer is a user application that sends messages.
* A queue is a buffer that stores messages.
* A consumer is a user application that receives messages.

**For more detailed information,  please read** [Detailed Exchanges and Queues](Docs/ExchangeDetail.md)

### Message Format

The entire QumuloAlerts infrastructure is heavily dependent on an agreed upon message structure. This
section of the document will outline a proposed message structure.

Please remember that the publisher will send a message and **every single** consumer will receive that
message. So, a common message format that is agreed upon by both the publisher and the consumer is
paramount.

One thing that the publisher should never do is format the data in any way. This will be a function
solely done by any given consumer.

An example would be a quota notification. The publisher should only pass a message that a quota has hit
some watermark and should not format the message for human readable viewing in any way. When you think
of the many possible consumers, this makes perfect sense. An email consumer may format a quota notification
with colors that represent each watermark in a message. Watermarks may be, but are not limited to, low,
medium and high (or 50, 70, 90% of quota attainment), A completely different consumer may take that same
quota attainment message and store it in a database for historical purposes. A third consumer may take that 
same message and forward it with a little processing to a external service like ServiceNow or HPE InfoSight.

The format of any given message will be a json dictionary. An example would be:

```
{
    "msg_version": Number,
    "datetime": String,
    "cluster_name": String,
    "plugin_name": String,
    "plugin_category": String,
    "plugin_subcategory": String,
    "message": Object
}
```

Each field is defined as:

- **msg_version** - The version of the message. This field would probably not be useful for message processing. It is instead necessary to represent
 the fields that would be included in the message. A consumer should know how to handle a message based upon the version of the message and the data that would be contained within the message based upon that version.
- **datetime** - json does not specify how dates should be represented. So, we have chosen to represent them as `2012-04-23T18:25:43.511Z`. These are human readable, sortable, and easily converted back to native datetime format.
- **cluster_name** - The cluster that generated the message. This must be unique. There should never be two clusters with the same name.
- **plugin_name** - The name of the plugin that generated the message. This must be unique, so the developer should take care to make sure that no two plugins have the same name.
- **plugin_category** - The category of the plugin that generated the message. This will always be one of "Alerts", "Informational", or "Alarms".
- **plugin_subcategory** - The subcategory of the plugin that generated the message. 
- **message** - A json dictionary unique to the particular message. This message will only be known between the provider and the consumer.


## Publisher

The detailed design documentation for the publisher can be found @ [Publisher Documentation](Docs/Publisher.md)

## Consumer(s)

The detailed documentation for a generic consumer can be found @ [Consumer Documentation](Docs/Consumer.md)

## Help

To post feedback, submit feature ideas, or report bugs, use the [Issues](https://github.com/Qumulo/QumuloAlerts/issues) section of this GitHub repo.

## Copyright

Copyright © 2022 [Qumulo, Inc.](https://qumulo.com)

## License

[![License](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)

See [LICENSE](LICENSE) for full details

    MIT License
    
    Copyright (c) 2022 Qumulo, Inc.
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## Contributors

 - [Berat Ulualan](https://github.com/beratulualan)
 - [Michael Kade](https://github.com/mikekade)
