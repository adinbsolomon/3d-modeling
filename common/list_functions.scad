
use <comparison_utils.scad>

function is_list_of_len(list, length) = 
    is_list(list) && len(list) == length;

function list_sublist(list, start, end) = 
    assert(is_list(list))
    assert(is_num(start))
    assert(number_is_between(start, 0, len(list)))
    assert(is_num(end))
    assert(
        end == -1 ||
        number_is_between(end,1,len(list),inclusive_higher=true))
    let(
        first = start,
        last = end==-1 ? len(list) : end
    )
        [
            for (i = [start : 1 : end-1]) list[i]
        ];


function list_sum(list, start=0, end=-1) =
    assert(is_list(list))
    assert(is_num(start))
    assert(number_is_between(start, 0, len(list)))
    assert(is_num(end))
    assert(
        end == -1 ||
        number_is_between(
            end,start,len(list),
            inclusive_lower=false,
            inclusive_higher=true
        )
    )
    let(
        first = start,
        last = end==-1 ? len(list) : end
    )
        first == last - 1 ?
        list[first] : 
        list[first] + list_sum(
            list, first+1, last
        );

// This is for taking a cross section of a list of lists. For example:
// list_cross_section([[1,2], [3,4], [5,6]], 1) will return [2, 3, 4].
function list_cross_section(list, index) =
    [
        for (i = [0:len(list)]) list[i][index]
    ];
