use array::ArrayTrait;

fn main() -> usize {
    let mut arr = ArrayTrait::new();
    arr.append(10);
    arr.append(11);
    arr.append(12);
    arr.len()
}