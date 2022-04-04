#!/usr/bin/env python
# coding=utf-8
import tensorflow as tf
import numpy as np
tf.compat.v1.disable_eager_execution()
a = tf.random.uniform(shape=[10], minval=-1, maxval=5, dtype=tf.int32)
b = tf.random.uniform(shape=[10], minval=-1, maxval=5, dtype=tf.int32)
with tf.device("/MY_DEVICE:0"):
   eagle = tf.add(a, b)

with tf.device("/CPU:0"):
    cpu = tf.add(a, b)

sess = tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(allow_soft_placement=False, log_device_placement=True))
print(sess.run(eagle))
print(sess.run(cpu))
