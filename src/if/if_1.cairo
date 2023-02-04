fn main() {
    let x = 25;
    if x == 0 {
        debug::print_felt('x is equal to 0');
    } else if x == 1 {
        debug::print_felt('x is equal to 1');
    } else {
        debug::print_felt('x is not equal to 0 or 1');
    }
}