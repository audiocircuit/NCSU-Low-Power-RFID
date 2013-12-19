/* 
 * File:   main.cpp
 * Author: deathmonkey
 *
 * Created on December 19, 2013, 1:57 PM
 */

#include <cstdlib>
#include <stdio.h>
using namespace std;

/*
 * 
 */
void dosomething(int *array);

int main(int argc, char** argv) {

    int array[2] = {0, 0};
    dosomething(array);
    printf("%d, %d", array[0], array[1]);
    return 0;
}

void dosomething(int *array)
{
    array[0] = 56;
    array[1] = 78;
}




