# FlowerShop

This is my proposed solution for the [flowershop problem](https://drive.google.com/open?id=0Bz8ZfUbKKW9DZWU3UzVadk1uZE0) written in Ruby.

## Environments

+ This application was developed in Ubuntu 14.04 64-bit 
+ Line endings might need to be converted on Windows

## Pre-requisites

+ ruby interpreter (preferably ruby 2.2.4p230 (2015-12-16 revision 53155) [x86_64-linux])
+ internet connection if you want to run the tests (for bundle install)
+ 

## Usage

Input file format

+ text file
+ this contains the customer's order list of items
+ space delimited values `XXX YYYY`
+ `XXX` is a number which represents a quantity
+ `YYYY` is string of numbers and letters which represents an item code

12 R234
34 E435
4 W234
55 F22

Make the main script executable

	$ cd FlowerShop/bin
	$ chmod a+x flowershop

Run the script

	$ ./flowershop --file input.txt

Run the tests

	$ bundle install
	$ rake test

## Sample Output

	$./flowershop -file input.txt 
	10 R12 $12.99
	     1 X 10 $12.99
	15 L09 $41.90
	     1 X 6 $16.95
	     1 X 9 $24.95
	13 T58 $25.85
	     1 X 3 $5.95
	     2 X 5 $9.95
