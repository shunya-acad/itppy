# gcd_module

# functions


def calc_gcd(num_1, num_2):
    rem = num_1 % num_2
    while rem != 0:
        num_1, num_2 = num_2, rem
        rem = num_1 % num_2
    return num_2
