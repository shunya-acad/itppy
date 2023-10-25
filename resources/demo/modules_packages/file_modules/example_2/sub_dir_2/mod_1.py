print('-'*50)
print('importing module 1 in sub dir 2')

from ..sub_dir_1 import mod_1 as sd1_mod_1

x = 20
y = "y in module 1 in sub dir 2"

def f1():
    print(f'calling f1 from mod 1 in sub dir 1:\n{sd1_mod_1.f1()}')
    print(y)

print('-'*50)