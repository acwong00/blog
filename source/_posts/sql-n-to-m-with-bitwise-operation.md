---
title: 使用位运算处理关系型数据库多对多关系
date: 2018-05-19 17:53:23
tags: [SQL,位运算,数据库设计,关系型数据库]
categories: 学习笔记
---

最近在工作当中需要处理一个本地 SQLite 数据库多对多查询的需求，一般情况下关系型数据库多对多关系都是通过一张关系表来记录，令多对多关系变成一对多关系来处理，但是相对来说这样的设计查询效率会较差。下面就记录一下这次使用二进制按位运算的方法来解决多对多的问题。

## 定义数据库结构

定义科目和学生是多对多的关系，分别使用科目表和学生表来储存数据。以 SQLite 为例。

**科目表 subject**

字段 | 描述
---- | ----
id | 自增id
subject_name | 科目名
subject_bit | 记录二进制位 1 的十进制数

科目表里面的 subject_bit 是一个十进制数，记录的是当前的科目对应的是哪个二进制位的一，举个例子：

- 256 代表二进制 100000000
- 1024 代表二进制 10000000000

**学生表 student**

字段 | 描述
---- | ----
id | 自增id
student_name | 学生名
subjects | 记录各学科按位或的结果

学生表里面的 subjects 字段同样是一个十进制数，记录的是学习对应的各个科目 subject_bit 按位或运算的结果，举个例子：

- 10 代表学生同时选修 subject_bit 为 2 和 8 的科目
- 1025 代表学生同时选修 subject_bit 为 1 和 1024 的科目

## 数据查询

示例数据

**subject**

id | subject_name | subject_bit
---- | ---- | ----
1 | 语文 | 1
2 | 数学 | 2
3 | 英语 | 4
4 | 政治 | 8
5 | 地理 | 16
6 | 历史 | 32
7 | 物理 | 64
8 | 生物 | 128
9 | 化学 | 256

**student**

id | student_name | subjects
---- | ---- | ----
1 | Amy | 234
2 | Bill | 34
3 | Cody | 3
4 | David | 15
5 | Eva | 26

**根据科目查询所属学生**

```sql
SELECT * FROM student WHERE subject_bit & 32 != 0
```

id | student_name | subjects
---- | ---- | ----
1 | Amy | 234
2 | Bill | 34

**根据学生查询科目**

```sql
SELECT * FROM subject WHERE subject_bit & 
(SELECT subjects FROM student WHERE student_name = 'Cody') != 0
```

id | subject_name | subject_bit
---- | ---- | ----
1 | 语文 | 1
2 | 数学 | 2

## 后记

虽然这种方式能够提高部分查询效率，但是同样有非常大的局限性。

首先，以二进制方式来标识类目的方法要将类目数量限制在 32 个以下。然后，虽然查询的 SQL 语句并不复杂，但是当要修改数据的时候就会非常麻烦。

因为笔者本次开发的需求是一个纯查询的数据库，而且类目数量少于 32 所以采取了这个方案，大家参考的时候必须要结合自身的需要。