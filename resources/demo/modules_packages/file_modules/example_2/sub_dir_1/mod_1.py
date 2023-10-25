print('-'*50)
print('importing module 1 in sub dir 1')

x = "y in module 1 in sub dir 1"

def f1():
    print(x)

if __name__ == "__main__":
    print('-'*30)
    f1()
    print(f'{__file__=}')
    print(f'{__package__=}')
    try:
        print(f'{__path__=}')
    except NameError as e:
        print("Error: ", e)
    print('-'*30)

print('-'*50)