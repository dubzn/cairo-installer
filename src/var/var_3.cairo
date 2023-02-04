fn main() -> felt {
    let mut n = 1;
    b(ref n);
    n
}

fn b(ref n: felt){
    n = 1;
}