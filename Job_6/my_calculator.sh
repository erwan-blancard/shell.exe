num1=$1
symbol=$2
num2=$3

if [ $symbol == '+' ]; then
	echo $(expr $num1 '+' $num2)
elif [ $symbol == '-' ]; then
	echo $(expr $num1 '-' $num2)
elif [ $symbol == 'x' ]; then
	echo $(expr $num1 \* $num2)
elif [ $symbol == '/' ]; then
	echo $(expr $num1 '/' $num2)
else
	echo "Invalid operator. If you're trying to multiply 2 numbers, use the letter \"x\" instead."
fi
