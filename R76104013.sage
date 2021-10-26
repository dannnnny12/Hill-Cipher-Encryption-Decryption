import sys
from sage.all import *
import fileinput
import numpy as np
import string

path = 'Key.txt'
def ReadKey(keyFileName):
    global numOfSupportCode
    global KeyMatrixDim
    row_num=0; K=None
    keyFile=open(keyFileName,"r") #read the key file
    if (keyFile is None):
        return None
    for line in keyFile:
        line=line.strip() #移除頭尾符號
        row=line.split("\t") #用tab分隔
        row=[int (num_str) for num_str in row] #list to int
        col_len=len(row)
        #print(row) #確認row正確
        #print(col_len)#確認row長度正確
        if (col_len < 2):
            print("Key matrix must be a nxn matrix,n must be greater than 1")
        if (col_len-1 < row_num):
            print("Key matrix must be a nxn matrix")

        if (row_num == 0):
            K = matrix(ZZ,col_len)
        K.set_row(row_num, row)
        row_num = row_num + 1

    numOfSupportCode=128
    KeyMatrixDim=col_len
    print("Key matrix:")
    print(K) #確認KEY的陣列正確
    keyFile.close()
    return K

Key=ReadKey(path)


K = Matrix(IntegerModRing(26), Key)
#讀入plaintext檔案
hillCipherInput_File=open("Original.txt", "r")
#print(hillCipherInput_File.read()) #確認讀入plaintext的file內容正確

numbers = [ord(letter) - 97 for letter in hillCipherInput_File.read()] #list
my_array = np.array(numbers)

m = np.asmatrix(my_array)
l = np.asmatrix(K)

CH = m * l

ls = np.asarray(CH)

def get_mod(num):
    rs = (97+(int(num) % 26))

    return chr(rs)


cvt_vec= np.vectorize(get_mod)

my_alph_array = cvt_vec(ls)
print("加密後文字:")
print(my_alph_array)

print("inverse matrix of K")
print(K.inverse()) #檢查Key之逆矩陣
inv=K.inverse()
K_inv_matr=np.asarray(inv)

deCH=K_inv_matr*ls
print("Deciphered text(Original Text):")
mu= np.dot(ls, K_inv_matr)
print(cvt_vec(mu))

#將ciphered的output寫入file
fo = open("Output.txt", "w")
ans=""
for i in np.squeeze(cvt_vec(ls)):
    ans = ans+i
fo.write(ans)
fo.close()

#將deciphered的output寫入file
fd = open("DecipheredText.txt", "w")
dec=""
for i in np.squeeze(cvt_vec(mu)):
    dec = dec+i
fd.write(dec)
fd.close()





hillCipherInput_File.close()