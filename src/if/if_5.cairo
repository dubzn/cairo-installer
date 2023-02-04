fn main() {
    let age = 15;
    if !is_greater(age) {
        debug::print_felt('is less');
    } else {
        debug::print_felt('is greater');
    } 
}

fn is_greater(age: felt) -> bool {
    age >= 18
}
