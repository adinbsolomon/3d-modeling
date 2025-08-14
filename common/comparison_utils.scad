
function number_is_between(
    number,
    lower_bound,
    higher_bound,
    inclusive_lower = true,
    inclusive_higher = false
) =
    assert(is_num(number))
    assert(is_num(lower_bound))
    assert(is_num(higher_bound))
    assert(is_bool(inclusive_lower))
    assert(is_bool(inclusive_higher))
    let(
        lower = inclusive_lower ? lower_bound-1 : lower_bound,
        higher = inclusive_higher ? higher_bound+1 : higher_bound
    )
        lower < number && number < higher;
