use array::ArrayTrait;

fn main() {
    let mut arr = ArrayTrait::new();
    arr.append(10);
    arr.append(11);
    arr.append(12);
    let pos2 = arr.at(2_usize);
    debug::print_felt(pos2);
}