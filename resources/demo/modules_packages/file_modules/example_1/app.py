print("-"*80)
print("Loading module: ", f'{__name__ = }\n{"-"*50}')
print(f'{__file__ = }\n{"-"*50}')

x = 10
y = "abc"

def some_func(): pass

class SomeClass: pass

try:
    print(f'{__path__ = }\n{"-"*50}')
except NameError as e:
    print(f'{e}\n{"-"*50}')

try:
    print(f'{__package__ = }\n{"-"*50}')
except NameError as e:
    print(f'{e}\n{"-"*50}')

if __name__ == '__main__':
    print(f'From main block: {__name__ = }\n{"-"*50}')

print("-"*80)