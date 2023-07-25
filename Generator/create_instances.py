# this file calls grid_generator_starting_assumptions.py with a number of different parameters,
# and stores them in the instances folder.
#
# how many instances? 
# k= 4,5,7
# n= 100, 200, 400, 500, 700, 1000, 2000, 3000, 4000, 5000

# rules_per_atom = [1, 2, 3] - pick randomly one number in that interval
# size_of_body = [0 - len(neighbours)] - pick randomly one number in that interval

import subprocess

k = [2, 3, 5, 6, 7]
n = [10, 20, 100, 200, 400, 500, 700, 2000, 3500, 6500, 7800]# 700, 1000, 2000, 5000, 10000]

for length in n:
    for width in k:
        i =0
        for i in range(1,5):
            call = "python3 grid_generator_starting_assumptions.py "+ str(width) +" "+ str(length)+ " "+str(i)
            process = subprocess.Popen([call], shell=True)
            i+=1
