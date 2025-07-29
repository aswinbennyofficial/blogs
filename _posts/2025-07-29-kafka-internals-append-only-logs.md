---
title: "Kafka Internals as Append-Only Logs"
date: 2025-07-29
categories: [compile, architecture]
tags: [kafka, streaming, logs, backend, distributed-systems]
image: /assets/img/posts/kafka-internals-append-only-logs-1.png
description: >-
  Deep dive into Apache Kafka's internal log-based architecture. Understand topics, 
  partitions, segments, and offsets with real-world examples. Learn how Kafka achieves 
  high-throughput message processing through append-only logs and distributed design.
---


Apache Kafka is often called a *distributed commit log*, but what does that mean in practice? This guide unpacks Kafka’s internal log-based architecture—covering topics, partitions, segments—and shows how these components enable high-throughput, scalable message processing.

---

## 🧠 Topic

- A **topic** is a logical container grouping messages, like a folder.
- It holds one or more **append-only log files**.
- Topics are split into **partitions** to enable parallelism and scalability.

## 📄 Partition

- Each **partition** is a single append-only log.
- It preserves message order *within* itself.
- Appending is a fast, sequential write to disk.
- Multiple partitions allow multiple producers and consumers to work concurrently.

## 📦 Segment

- Kafka divides partitions into fixed-size **segments** (e.g., 1 GB each).
- Each segment is an individual file stored on disk.
- New segments are created once size or time thresholds are met.
- Old segments are deleted or compacted according to configured **retention policies**.

## 🔢 Offset

- An **offset** uniquely identifies a message’s position within a partition.
- It starts at 0 and increments with every message.
- Consumers use offsets to keep track of their reading progress.

## ✍️ Producer

- Producers send data to topics and choose partitions based on:
  - A **deterministic key** (e.g., hash of the key), or
  - **Round-robin** strategy (default)
- Messages are appended in a **write-ahead log** fashion.

## 📥 Consumer

- Consumers read messages from specific topic partitions by offset.
- Kafka guarantees ordering only within partitions.
- Each consumer tracks offsets on a per-partition basis (manually or automatically).

## 🧱 Broker

- A **broker** is a Kafka server holding data.
- It manages partitions, segments, and associated index files.
- Brokers handle replication, client requests, and leadership elections.

## 🔁 Replication

- Partitions have one **leader** and multiple **followers**.
- Followers replicate the leader’s log in real-time.
- This replication ensures **fault tolerance and data durability**.

## 🧹 Log Compaction

- Log compaction retains only the most recent record for each key.
- Useful for topics that represent **state changes**.
- Compaction runs in the background and preserves the append-only nature of logs.

---

## 🛍️ Real-World Analogy: Kafka for User Activity Logs

### Example: E-commerce Clickstream

- **Topic:** `user-clicks`
- **Partitions:**
  - Partition 0 → users where `hash(key) % 3 == 0`
  - Partition 1 → `hash(key) % 3 == 1`
  - Partition 2 → `hash(key) % 3 == 2`

### Example Segment Files

```
/kafka-logs/user-clicks-0/00000000000000000000.log
/kafka-logs/user-clicks-1/00000000000000000000.log
/kafka-logs/user-clicks-1/00000000000001000000.log
/kafka-logs/user-clicks-2/...
```

### Kafka Log Structure Mapping

| Kafka Term | Log Analogy        | Example                           |
| ---------- | ------------------ | --------------------------------- |
| Topic      | Directory of logs  | `user-clicks`                     |
| Partition  | Log file           | `user-clicks-1`                   |
| Segment    | Rotated chunk file | `00000000000001000000.log`        |
| Offset     | Line number        | `1234`                           |
| Producer   | Log appender       | Appends to `user-clicks-1`        |
| Consumer   | Log reader         | Reads from `user-clicks-1` @ 1234 |

---

## 🎯 Consumer & Partition Selection

### Offset is Partition-Specific

- Offset 500 in Partition 0 is completely independent from Offset 500 in Partition 1.
- Consumers must keep track of offsets for each partition separately.

### How Consumers Get Partitions

1. **Consumer Groups**

   - Kafka automatically assigns partitions to consumers within a group.
   - Offsets are committed in the context of consumer groups.

2. **Manual Assignment**

   - Applications can manually assign specific partitions.
   - Offsets can be explicitly specified (e.g., from start, end, or a checkpoint).

---

Kafka’s append-only log design is the foundation of its performance and reliability. Grasping these internals empowers you to design more efficient systems, especially suited for event-driven architectures, real-time analytics, and distributed data pipelines.
