import cat_1.gcd_module

num_1, num_2 = 9, 6

gcd = cat_1.gcd_module.calc_gcd(num_1, num_2)

if __name__ == "__main__":
    print(80*'-')
    print(f'greatest common divisor of {num_1} and {num_2} is: {gcd}')
    print(80*'-')
