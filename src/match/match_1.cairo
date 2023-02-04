fn main() -> felt {
    let a = 25;
    match_test(a)
}

fn match_test(a: felt) -> felt {
    match a {
        0 => 15, 
        _ => 0,
    }
}