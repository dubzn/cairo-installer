use array::ArrayTrait;

fn main() {
    let mut arr = ArrayTrait::new();
    arr.append(10);
    arr.append(11);
    arr.append(12);
    
    match arr.pop_front() {
        Option::Some(x) => {
            debug::print_felt(x);    
        },
        Option::None(_) => {
            debug::print_felt('None');
        },
    };
}