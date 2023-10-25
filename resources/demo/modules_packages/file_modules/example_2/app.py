import sub_dir_1.mod_1 as mod_1_1
import sub_dir_1.mod_2
import mod_0

if __name__ == "__main__":
    print('-'*30)
    mod_1_1.f1()
    # mod_1_2.f1()
    print(f'{__file__=}')
    print(f'{__package__=}')
    try:
        print(f'{__path__=}')
    except NameError as e:
        print("Error: ", e)
    print('-'*30)