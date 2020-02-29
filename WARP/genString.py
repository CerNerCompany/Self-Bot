import sys
import string
import random
import datetime
def genString(stringLength):
    letters = string.ascii_letters + string.digits
    return ''.join(random.choice(letters) for i in range(int(stringLength)))
print(genString(sys.argv[1]))

 