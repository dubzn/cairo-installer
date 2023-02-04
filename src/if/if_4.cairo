fn main() {
    let x = 1;
    if x != 0 | x >= 25 {
        debug::print_felt('x is not equal to 0');
        debug::print_felt('or');
        debug::print_felt('x is greater than or equal to 25');
    } else {
        debug::print_felt('x is equal to 0');
        debug::print_felt('or');
        debug::print_felt('x is less than 25');
    }
}