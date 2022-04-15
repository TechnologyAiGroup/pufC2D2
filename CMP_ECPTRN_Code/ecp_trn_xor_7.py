### ECP-TRN Code ######
#
# author: Pranesh Santikellur
########################

#!/usr/bin/python
import sys, os

import tensorflow as tf
import numpy as np
import pandas as pd
from tensorflow.examples.tutorials.mnist import input_data
from TRL import *
from sklearn.model_selection import train_test_split
import time
start_time = time.time()


nSamples=320000

# the training set and test set data
df1=pd.read_csv('./TRN_Data_Generation/PCA_6APUF_XOR_Challenge_Parity_64_320k_3.csv',header=None,chunksize=nSamples)
df1=df1.get_chunk()
df2=pd.read_csv('./TRN_Data_Generation/6-xorpuf_64_320k_3.csv',header=None)
X = df1.iloc[:nSamples,:]
Y = df2.iloc[:nSamples,:]

tf.set_random_seed(1)
features=X.values
labels=Y.values

batch_size=80000
train_features, test_features, train_labels, test_labels = train_test_split(features, labels, test_size = 0.2, random_state = 42)


total_size = train_features.shape[0]
number_of_batches = int(total_size/batch_size)
print("no. of batches : %d" % number_of_batches)

print("Number of examples in training set: {}".format(train_features.shape[0]))
print("Number of examples in cross validation set: {}".format(test_features.shape[0]))

features_placeholder = tf.placeholder(features.dtype, features.shape)
labels_placeholder = tf.placeholder(labels.dtype, labels.shape)

dataset = tf.data.Dataset.from_tensor_slices((features_placeholder, labels_placeholder))


def main(rank = None, file = None, f_error = None, f_acc = None):
	

	with tf.Session() as sess:

		#the input data dimension
        #the number of times the data is repeated indicates the number of APUFs
########################################################################################
		y1 = tf.placeholder(tf.float32, shape = [None, 129,129,129,129, 129,129])
		x = tf.placeholder(tf.float32, shape = [None, 129])
#######################################################################################
		
		# the correct answer y_
		y_ = tf.placeholder(tf.float32, [None, 1])
		
		#out = ttrl(x, rank, 1)
		out = ecp_trn(x,y1, rank, 1)
		
		# cross entropy comparing y_ and y_conv
		vars1   = tf.trainable_variables()
		lossL2 = tf.add_n([ tf.nn.l2_loss(v) for v in vars1  if 'bias' not in v.name ]) * 0.0001 #learning rate


		cross_entropy = tf.reduce_mean(tf.nn.sigmoid_cross_entropy_with_logits(labels=y_, logits=out)) + lossL2
		
		
		# train step with adam optimizer
		train_step = tf.train.AdamOptimizer(8*1e-3).minimize(cross_entropy)
		
		# check if they are same
		predicted = tf.nn.sigmoid(out)
		correct_prediction = tf.equal(tf.round(predicted), y_)
		
		# accuracy
		accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
		sess.run(tf.initialize_all_variables())

		for i in range(8000):
			###############################################
			for j in range(number_of_batches):
				mini_x = train_features[j*batch_size:(j+1)*batch_size, :]
				mini_y = train_labels[j*batch_size:(j+1)*batch_size, :]
			################################################
				if j%100 == 0:
					train_accuracy = accuracy.eval(feed_dict={
							x:mini_x, y_: mini_y})
					train_error = cross_entropy.eval(feed_dict={
							x:mini_x, y_: mini_y})
					print ("step %d and train acc. %g and error : %g"%(i,train_accuracy,train_error))

					f_error.write("%d \t %g\n" % (i,train_error))
					f_acc.write("%d \t %g\n" % (i,train_accuracy))

					if( i%20 == 0 ):
						end_time = (time.time() - start_time)
						print("\n\n--- time for learning : %s seconds ---\n" % end_time)
						file.write("\n\n--- time for learning : %s seconds ---\n" % end_time)

					file.write("step %d, training accuracy %g\n"%(i, train_accuracy))
				a = sess.run(train_step, feed_dict={x: mini_x, y_: mini_y})

            #the accuracy of the test set
			val_acc = accuracy.eval(feed_dict={x: test_features, y_: test_labels})
			print("test accuracy %g\n"%val_acc)
			file.write("test accuracy %g\n"%val_acc)
			if(val_acc > 0.97) :
				print("\n\n\n yipee found it \n\n\n")
				file.write("\n\n\n yipee found it \n\n\n")



def run(outfilepath, rank, iter):
	with open(outfilepath,"w+") as f, open("log22_error_graph.txt","w+") as f_error, open("log22_acc_graph.txt","w+") as f_acc:
		for i in range(iter):
			main(rank = rank, file = f, f_error = f_error, f_acc = f_acc)
			tf.reset_default_graph()
		f.write("\n")
		f_acc.write("\n")
		f_error.write("\n")
		end_time = (time.time() - start_time)
		print("\n\n--- time for learning : %s seconds ---\n" % end_time)
		f.write("\n\n--- time for learning : %s seconds ---\n" % end_time)

if __name__ == '__main__':

	run("log22_3.txt", 10		, 1)
