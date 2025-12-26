
use <list_functions.scad>

constant_list = [1, 1, 1, 1, 1];
counting_list = [1, 2, 3, 4, 5];
index_list = [0, 1, 2, 3, 4];

assert(list_sum(counting_list) == 15);
assert(list_sum(counting_list, start=1) == 14);
assert(list_sum(counting_list, start=1, end=4) == 9);
assert(list_sum(counting_list, end=0) == 0);
assert(list_sum(constant_list, 0, 1) == 1);
