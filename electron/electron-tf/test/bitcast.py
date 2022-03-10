#!/usr/bin/env python
# coding=utf-8
import tensorflow as tf
import numpy as np
tf.compat.v1.disable_eager_execution()
a = tf.random.normal(shape=[10], dtype=tf.float32)

with tf.device("/MY_DEVICE:0"):
    eagle = tf.bitcast(a, tf.float16)

with tf.device("/CPU:0"):
    cpu = tf.bitcast(a, tf.float16)

sess = tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(allow_soft_placement=False, log_device_placement=True))
print(sess.run(tf.reduce_all(tf.less(eagle - cpu, 1e-5))))
