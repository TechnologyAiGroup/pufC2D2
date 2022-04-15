#!/usr/bin/python
import sys, os

import tensorflow as tf
import numpy as np

#Tensor Neural Network Architecture Code
#Tensor regression layer (TRL).

def ecp_trn(x,y1, rank, n_outputs):
	weight_initializer = tf.contrib.layers.xavier_initializer(0)
	input_shape = y1.get_shape().as_list()[1:]
		
	bias = tf.get_variable("bias_{}".format(np.prod(n_outputs)), shape=(1, np.prod(n_outputs)))

	rank1_tnsrs = []

	for i in range(rank):
		rank1_tnsr = []

		for j in range(len(input_shape)):
			rank1_tnsr.append(tf.get_variable("rank1_tnsr_{0}_{1}_{2}".format(i,j,np.prod(n_outputs)), 
				shape = (input_shape[j]), 
				initializer = weight_initializer))

		rank1_tnsr.append(tf.get_variable("rank1_tnsr_{0}_output_{1}".format(i,np.prod(n_outputs)), 
			shape = (n_outputs), 
			initializer = weight_initializer))

		rank1_tnsrs.append(rank1_tnsr)
	#The tensor data dimension use the PC-enhanced LAD Model I
	###########################################################
	x= tf.reshape(x, [-1, 129])
	#########################################################
	cout=tf.zeros([n_outputs],tf.float32)
	for j in range(0,len(rank1_tnsrs)):
		tout=tf.multiply(tf.scalar_mul(1,tf.matmul(x,tf.reshape(rank1_tnsrs[j][0], [-1,1]))),tf.scalar_mul(1,tf.matmul(x,tf.reshape(rank1_tnsrs[j][1], [-1,1]))))
		for k in range(2,len(rank1_tnsrs[j])-1):
			tout=tf.multiply(tout,tf.scalar_mul(1,tf.matmul(x,tf.reshape(rank1_tnsrs[j][k], [-1,1]))))
		tout=tf.multiply(tout,tf.reshape(rank1_tnsrs[j][k+1], [-1,1]))
		cout = tf.add(cout,tout)
	#cout=tf.multiply(tf.scalar_mul(10,wscale),cout)
	return tf.add(cout,bias)

