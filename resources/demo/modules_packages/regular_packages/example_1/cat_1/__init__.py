# using relative import is needed for using gcd_module.__all__

if __name__ == "__main__":
    print('-'*30)
    print(f'{__file__=}')
    print(f'{__package__=}')
    try:
        print(f'{__path__=}')
    except NameError as e:
        print("Error: ", e)
    print('-'*30)
