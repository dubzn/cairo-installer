fn main() {
    let x = 10;
    let y = 20;
    if x < y {
        debug::print_felt('x is less than y');
    }
    if x <= y {
        debug::print_felt('x is less than or equal to y');
    }
    if x > y {
        debug::print_felt('x is greater than y');
    }
    if x >= y {
        debug::print_felt('x is greater than or equal to y');
    }
}