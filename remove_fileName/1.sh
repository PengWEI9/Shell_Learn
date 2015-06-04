#!bin/shell
#Data 04/06/2015
#Author: Peng
#Email: peng.wei8899@gmail.com

#V1.0

for f in *.c
do 
	t=${f}
	echo $t 
	t=${f%think*}.c

	mv $f $t
done
#/
