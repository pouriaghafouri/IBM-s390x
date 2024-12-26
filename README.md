<h1>Prerequisites</h1>
To run programs written in s390x assembly, you need <strong>QEMU</strong>.</br>
You can obtain this emulator using the following bash commands:

```
sudo apt update
sudo apt upgrade
sudo apt install gcc-s390x-linux-gnu
sudo apt install qemu-user
```

<h1>How to run</h1>
This repository contains several sample codes written in IBM s390x assembly language.</br>
In the tools folder, there is a script named `ibm`, which you can use to execute your code. To run your code using this script, use the following command:

```
./ibm code
```
The above command runs the `code.s` file.
This folder also includes a file named `macro.s`, which contains several useful macros. You can either use these macros as they are or modify them as needed.
The `samples` folder contains multiple sample codes, with a description of each provided below:
  1.  Hello World
  2.  Division Operation
  3.  Multiplication Using Different Instructions
  4.  Question 1 from Exercise 3 of Dr. Asadi's CSL Course
  5.  Convert Uppercase Letters to Lowercase in a String
       - Takes a string containing uppercase and lowercase English letters as input and converts all uppercase characters to lowercase.
  6.  Reverse the Input of n Numbers
       -  Takes n numbers as input and outputs them in reverse order.
  7.  Operations on Floating-Point Numbers
  8.  Recursive Calculation of Factorial
       -  Calculates the factorial of the input number using recursion.
