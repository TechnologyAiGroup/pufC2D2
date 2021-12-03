![](C:\Users\24556\Desktop\图片\图片备份\信号灯修改图2\信号灯FPGA板.jpg)

- The hardware platform hosts a Xilinx Zynq-7000 FPGA (28 nm process technology).

- LED A：Reset signal. LED A on means the Reset is at high level; LED A off means the Reset is at low level.

- LED B: Determine whether the BRPUF circuit is in a stable state of 0101010101···or 1010101010··· When it is in a stable state, the LED B will be on, and the output of the BRPUF circuit can be recorded at this time. Otherwise light B will not light up.

- LED C: Output signal. When LED C is on, it means the output is 0. When LED C is off, it means the output is 1.

- Button 1: Reset. Press Button 1 to change the reset signal of the BRPUF circuit to high or low. The default is high when power on.

- Button 2: Run. Press Button 2 to apply the input challenge to the BRPUF circuit, one at a time. 

  

  We can actually use a third button (Button 3) from the platform, to pair up with Button 2. While Button 2 is used for apply the challenges to the BRPUF circuit incrementally, as C1, C2, … Ci, Ci+1, …, Button 3 can be used to apply the challenges in a decreasing order, as … Ci+1, Ci, …, C2, C1. This functionality is reserved for now. 

 

- Step-by-step instruction flow after power-on is as follows:
  1. Set the Reset signal to high level (LED A is on), so that the entire circuit is in a state of all zeros.
  2.  Press the Button 2 to apply the input challenge data.
  3. Press the Button 1 to set the reset signal line at low level (LED A is off). After the circuit is stable (LED B is on), the current output can be read as the response to the applied challenge, by reading the on/off signal given by LED C.
  4.  Go back to step 1, repeat this process to get another CRP.