# Detailed Info on Exchanges and Queues

## Introduction

This section will provide a little tutorial of how we plan on delivering messages from the publisher to any given consumer.

For QumuloAlerts, we will be using a mechanism whereby any given message passed from the publisher is routed to ALL consumers; regardless of the queue they are sitting on.
This is done through a mechanism called a fanout exchange. You should think of an exchange like you would a telephone operator. When a call comes in (in this case a message from the publisher), the telephone operator would
typically route that message to any given queue based upon the **routing key** in the message. With a fanout exchange, the routing key is ignored and all messages are passed to all consuming queues.

## Exchanges and Queues

The core idea in the messaging model in RabbitMQ is that the producer never sends any messages directly to a queue. Actually, quite often the producer doesn't even know if a message will be delivered to any queue at all.

Instead, the producer can only send messages to an exchange. An exchange is a very simple thing. On one side it receives messages from producers and the other side it pushes them to queues. The exchange must know exactly what to do with a message it receives. Should it be appended to a particular queue? Should it be appended to many queues? Or should it get discarded. The rules for that are defined by the exchange type.

![](./exchanges.png)

There are a few exchange types available: **_direct_**, **_topic_**, **_headers_** and **_fanout_**. We'll focus on the last one -- the fanout. Let's create an exchange of that type, and call it QumuloAlerts:

`channel.exchange_declare(exchange='QumuloAlerts', exchange_type='fanout')`

The fanout exchange is very simple. As you can probably guess from the name, it just broadcasts all the messages it receives to all the queues it knows. And that's exactly what we need for QumuloAlerts.

Now, from the publisher program, we can send a message to the QumuloAlerts exchange:

`channel.basic_publish(exchange='QumuloAlerts', routing_key='', body=message)`

As you can see, we are sending a message (body=message) to the routing_key of "". With a fanout exchange, the routing key doesn't matter as that **_telephone operator_** sends all messages to every single consuming queue and doesn't look at the routing key for message delivery.

Now that a message has been published, where did it go? Without a queue, the exchange will just drop the message that was just published. We need a queue of some kind to deliver the message to. 
Typically, each queue will have a name. But, for our example code, we will create a temporary queue with a random queue name.

`result = channel.queue_declare(queue='')`

At this point result.method.queue contains a random queue name. For example it may look like **_amq.gen-JzTY20BRgKO-HjmUJj0wLg_**.

Secondly, once the consumer connection is closed, the queue should be deleted. There's an exclusive flag for that:

`result = channel.queue_declare(queue='', exclusive=True)`

### Queue to Exchange Bindings

Once a queue and an exchange have been created, then you must bind the two together. Otherwise, the exchange will not know how to deliver the message from the exchange to the queue(s).

`channel.queue_bind(exchange='QumuloAlerts', queue=result.method.queue)`

![](./bindings.png)

So, what does it all look like when put together?

![](./python-three-overall.png)

Again, we won't ever be using auto-generated queue names. But, for this example, they will suffice.

You can see that a Producer generates a message which is delivered **only** to an exchange. The RabbitMQ system will take the message delivered to the exchange and route it to the appropriate queue(s). 
This is done through the **routing key**. In a fanout exchange as we are using, the routing key is ignored and all messages into the exchange are passed to every single queue bound to that exchange.

### Sample Publisher

This little sample program demonstrates what a publisher has to do to send a message to any consumer. Note
that we will not create or publish a message to a queue. This is not the job of the publisher. The consumer
defines what queue they will listen to. The messaging system (in this case RabbitMQ) will take the message
passed to the exchange and send it onto the consumers through the queues.

If there are no consumers when a message is published, then the messaging system will drop the message and delete it
since there is no queue to publish it to.

```
#!/usr/bin/env python

import pika
import sys

# Make a connection to RabbitMQ

connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

# Create an exchange called QumuloAlerts

channel.exchange_declare(exchange='QumuloAlerts', exchange_type='fanout')

# Publish a message to the exchange

message = "info: Hello World!"
channel.basic_publish(exchange='QumuloAlerts', routing_key='', body=message)

# Output a debug message and exit

print(f"Sent {message}")
connection.close()
```
### Sample Consumer

This little sample program demonstrates what a consumer has to do to receive a message from the publisher. 

The consumer needs to understand not only the queue they are using, but the exchange as well. This is because
the consumer usually starts before the publisher so that no messages are potentially lost. This is not mandatory
and the messaging system knows how to deal with either a publisher or a consumer starting in any order.

Note also that the consumer always uses a callback system. This makes for more efficient code as it is not known
when a publisher will send a message. 

```
#!/usr/bin/env python

import pika

# Make a connection to RabbitMQ

connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

# Create an exchange called QumuloAlerts

channel.exchange_declare(exchange='QumuloAlerts', exchange_type='fanout')

# Create a un-named queue. This won't be done in the real code, but works as a demonstration.

result = channel.queue_declare(queue='', exclusive=True)
queue_name = result.method.queue

# Bind the new queue to the exchange so that messages can be delivered

channel.queue_bind(exchange='QumuloAlerts', queue=queue_name)

# Define a callback routine to process the messages. For this demonstration, it will just print the message

def callback(ch, method, properties, body):
    print(f"{body}")

# Register the callback with the queuing system

channel.basic_consume(
    queue=queue_name, on_message_callback=callback, auto_ack=True)

# Now ask the queuing system to process messages. The code will reside in this routine until such time
# as it is terminated. Typically, you would handle a shutdown message in the callback.

channel.start_consuming()
```

