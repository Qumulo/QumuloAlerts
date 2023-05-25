# Publisher

## Table of Contents

   * [Introduction](#introduction)
   * [Overview](#overview)
   * [Design Flow](#design-flow-for-qumuloalerts)
   * [Plugin Design](#qumuloalerts-design)
   * [Help](#help)
   * [Copyright](#copyright)
   * [License](#license)
   * [Trademarks](#trademarks)
   * [Contributors](#contributors)

## Introduction

This document will discuss the design of the Publisher for the QumuloAlerts infrastructure.

We will use a pseudo language to outline the various procedures contained within the QumuloAlerts process.

## Overview

The publisher is a process that runs in docker. There is a publisher for each cluster defined in
the configuration file. See **QumuloAlerts.json** below. 

The publisher utilizes a number of plugins; where each plugin does one and ONLY one function.
For instance, what is the state of the disk subsystem? Or has a quota exceeded capacity?
In these examples, both the **disk** and the **quota** mentioned are plugins. 

The overall process is called QumuloAlerts and, as mentioned, one process is started
per cluster defined in the configuration file. The QumuloAlerts process will look
at the configuration file for that single cluster definition and determine which
plugins to load. Plugin configuration is also defined in the configuration file.

## Design Flow for QumuloAlerts

The following is pseudo code that outlines the flow of the QumuloAlerts process. We have
utilized pseudo code, since it is far easier to convey the idea of how the process is
supposed to execute. 
```
Open config file - QumuloExchange.json
Open connection to RabbitMQ based upon the config file info
    If it doesn't work
        abort

Open config file - QumuloAlerts.json
Loop through items in QumuloAlerts array
    Open connection to Qumulo cluster
        If it doesn't work
            abort
        
        Does the config file call for a Network Load Balancer (NLB)?
            If false,
                Get floating IP's
                    If they don't exist
                        abort
```

At this point, we have determined that the two configuration files exist and that they
are valid. In addition, we have opened connections to the RabbitMQ process (**the** Exchange)
and to each cluster defined in the configuration file.

Let's continue

```
For each cluster in the configuration file
    spawn a subprocess of QumuloAlerts (outselves) and pass it a single cluster name
        
Wait for the subprocesses to terminate
```

So, if the configuration file (**QumuloAlerts.json**) has two clusters defined, there
are now three processes running. In our code, we have called them primary and **secondary**.
In the above example, there are actual two secondaries; one for each cluster.

Let's now define what happens once the secondary starts up.

```

Open the configuration file (**QumuloALerts.json**)
Find the cluster definition for the cluster name passed into **this** secondary
Built a plugin filter that will only load the plugins defined in category and subcategory

Find all Plugins using filter
Load all Plugins

Loop through each plugin loaded
    Instantiate the plugin
    Activate the plugin
    Start the thread for the plugin
    
Wait for all of the plugins to stop 
```

## Config Files

**QumuloExchange.json**

This config file is used to open a communication to RabbitMQ and, additionally, specifies which exchange to use..

```
{
    "rabbitmq_cluster": "rabbitmq",
    "rabbitmq_port": 5672,
    "virtual_host": "QumuloProd",
    "exchange": "com.qumulo.alerts",
    "username": "qumulo",
    "password": "qumulo"
}
```

**QumuloAlerts.json**

This is an array specifying three things:

- Which cluster to communicate with
- Which features to monitor on that cluster (plugins)
- The number of seconds (frequency) to wait between polling intervals.

```
[
    {
	    "cluster_name": "cluster_1.qumulo.com",
	    "cluster_port": 8000,
	    "cluster_username": "USERNAME",
	    "cluster_password": "PASSWORD",
	    "nlb": false,
	    "frequency": 
	    {
	        "seconds": 5
	    },
	    "monitor": 
	    [
	        {
	            "category": "Alarms",
		        "subcategory": ["Disk", "Node"],
		        "enabled": true,
	        }
	    ]
    },
    {
	    "cluster_name": "cluster_2.qumulo.com",
	    "cluster_port": 8000,
	    "cluster_username": "USERNAME",
	    "cluster_password": "PASSWORD",
	    "nlb": false,
	    "frequency": {
	        "seconds": 5
	    },
	    "monitor": 
	    [
	        {
	            "category": "Alarms",
		        "subcategory": ["Disk"],
		        "enabled": true,
	        },
	            "category": "Alerts",
		        "subcategory": ["Quotas"],
		        "enabled": true
	        },
	            "category": "Informational",
		        "subcategory": ["SoftwareVersion"],
		        "enabled": true
	        }
        ]
    }
]
```

## Plugin Design

The QumuloAlerts provider does no actual work with a cluster other than to determine that a cluster exists.
Rather, the provider will load plugins from the provider directory. 

Each plugin polls for one Alarm / Alert / Informational piece of information on a cluster
and passes that information via a message to the RabbitMQ exchange for processing by a subscriber.

At the moment, the design calls for each plugin to run as a thread within the QumuloAlerts provider. 

A plugin should assume that the QumuloAlerts provider will provide no support to each plugin other than what is needed to start it as a separate thread.

There are four main methods within the class (__init__, Setup, Connect, Run).

It is assumed that the API to the Qumulo cluster and the RabbitMQ system are not re-entrant. Therefore,
Setup() should start the thread

```
Class Instantiation (frequency, rabbitmq info, cluster IP)
    Store __init__ arguments
    
Setup()
   Do any functions that pertain to the plugin
   (Perhaps like reading a plugin specific config file)
   
Connect()
    Connect to cluster using IP passed into plugin
    Connect to RabbitMQ Exchange
    
Run()
    Wait for frequency seconds to expire
    Do Plugin work
        Format message
        Send message to Exchange
```

## Help

To post feedback, submit feature ideas, or report bugs, use the [Issues](https://github.com/Qumulo/StorageReport//issues) section of this GitHub repo.

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
