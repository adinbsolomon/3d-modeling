
function xor(p, q) = 
    assert(is_bool(p), "Arguments must be boolean")
    assert(is_bool(q), "Arguments must be boolean")
    (p || q) && (p != q);
