#!/usr/bin/env python
# coding=utf-8
import tensorflow as tf
import numpy as np
tf.compat.v1.disable_eager_execution()
a = tf.random.normal(shape=[10])
#a = tf.constant(a)
b = tf.random.normal(shape=[10])
#b = tf.constant(b)
#with tf.device("/MY_DEVICE:0"):
#    eagle = tf.math.add(a, b)

with tf.device("/CPU:0"):
    cpu = tf.math.add(a, b)

sess = tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(allow_soft_placement=False, log_device_placement=True))
print(sess.run(cpu))
