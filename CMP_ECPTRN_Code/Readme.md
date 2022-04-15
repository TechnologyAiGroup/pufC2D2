1. This directory holds source codes to perform comparison experiments. We embed PC-enhanced LAD Model I into the ECP-TRN framework to improve its accuracy. ECP-TRN is the method proposed in a SOTA work from the paper,

   P. Santikellur and R. S. Chakraborty, "A Computationally Efficient Tensor Regression Network-Based Modeling Attack on XOR Arbiter PUF and Its Variants," in *IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems*, vol. 40, no. 6, pp. 1197-1206, June 2021.

2. ecp_trn_xor_7.py and TRL.py  are  python codes adopted from ECP-TRN, 

      Most of the codes are kept unchanged.

      The part we changed is denoted by "####################". For example, in ecp_trn_xor_7.py , 

      #################################################################################
         y1 = tf.placeholder(tf.float32, shape = [None, 129,129,129,129, 129,129])
         x = tf.placeholder(tf.float32, shape = [None, 129])
      #################################################################################

   ​    is where we made changes and is different from the orignal ECP-TRN code.

3. The following hyperparameters :

   - Rank 

   - Batch size
   - Learning rate

   ​    can be set in the  ecp_trn_xor_7.py .     

4. The  directory TRN_Data_Generation holds source codes to generate the training set and test set with  PC-enhanced LAD Model I.

   -   We write the functions TRN_Data_Generation and getPCAVector. Other functions can be found from the paper,

      P. H. Nguyen, D. P. Sahoo, C. Jin, K. Mahmood, U. R&#252;hrmair, and M. van Dijk, “The interpose PUF: Secure PUF design       against state-of-the-art machine learning attacks,” IACR Transactions on CHES, vol.2019, no. 4, pp. 243–290, Aug. 2019.

     

   -  Function description

     - TRN_Data_Generation.m: Generate XOR PUF data with  PC-enhanced LAD Model I , including the weights of XOR PUF instance, training set, and test set

     - getPCAVector.m: Get the PCA data by dealing with challenge data

     - XORPUFgeneration.m: Use a Gaussian distribution with a mean of 0 and a standard deviation of 0.05 to generate the weight vector of the XOR PUF instance

     - sampling.m: Randomly generate non-repetitive CRP data set

     - Transform.m: Conversion of challenge data by phi function (0,1)->(-1,1)

     - ComputeResponseXOR.m: Calculate the output of each APUF of XOR PUF

       

