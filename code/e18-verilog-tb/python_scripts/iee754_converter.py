from ieee754 import IEEE754, single

# Function for converting decimal to binary


# def float_bin(my_number, places = 3): 
# 	my_whole, my_dec = str(my_number).split(".")
# 	my_whole = int(my_whole)
# 	res = (str(bin(my_whole))+".").replace('0b','')

# 	for x in range(places):
# 		my_dec = str('0.')+str(my_dec)
# 		temp = '%1.20f' %(float(my_dec)*2)
# 		my_whole, my_dec = temp.split(".")
# 		res += my_whole
# 	return res

def case_statement_for_weights(arr):
	
    n = len(arr)
	
    to_power_n = 2**n
	
    bit_comb = per(n)
    writing=''
    for i in range(to_power_n):
		
        print("5'b"
			  +(''.join(map(str, bit_comb[i])))
			  +(': ')
			  +("mult_output = 32'h")
			  ,end='')
		
        sum=0
		
        for j in range(len(bit_comb[i])):
			
            if(bit_comb[i][j]==1):
				
                sum = sum + arr[j]
				
        print((str(single((float(sum))).hex()[0]))+';')
			
def per(n):
	arr = []
	for i in range(1<<n):
		s=bin(i)[2:]
		s='0'*(n-len(s))+s
		arr.append(list((map(int,list(s)))))
	return arr
		
# def IEEE754(n) : 
# 	# identifying whether the number
# 	# is positive or negative
# 	sign = 0
# 	if n < 0 : 
# 		sign = 1
# 		n = n * (-1) 
# 	p = 30
# 	# convert float to binary
# 	dec = float_bin (n, places = p)

# 	dotPlace = dec.find('.')
# 	onePlace = dec.find('1')
# 	# finding the mantissa
# 	if onePlace > dotPlace:
# 		dec = dec.replace(".","")
# 		onePlace -= 1
# 		dotPlace -= 1
# 	elif onePlace < dotPlace:
# 		dec = dec.replace(".","")
# 		dotPlace -= 1
# 	mantissa = dec[onePlace+1:]

# 	# calculating the exponent(E)
# 	exponent = dotPlace - onePlace
# 	exponent_bits = exponent + 127

# 	# converting the exponent from
# 	# decimal to binary
# 	exponent_bits = bin(exponent_bits).replace("0b",'') 

# 	mantissa = mantissa[0:23]

# 	# the IEEE754 notation in binary	 
# 	final = str(sign) + exponent_bits.zfill(8) + mantissa

# 	# convert the binary to hexadecimal 
# 	hstr = '%0*X' %((len(final) + 3) // 4, int(final, 2)) 
# 	return (hstr, final)

# Driver Code
if __name__ == "__main__" :
	print (IEEE754(159.45999999999998))
	print (IEEE754(-263.3))
	case_statement_for_weights([87.11, 0, 49.76, 18.92, 72.35])