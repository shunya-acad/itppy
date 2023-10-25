import utils

utils.func_fa1_1()

utils.func_fa2_1()

for k in globals().copy().keys():
    print(k)

print("-"*10 + "utils")
for k in utils.__dict__.keys():
    print(k)