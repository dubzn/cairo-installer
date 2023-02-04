enum MyEnumShort {
    a: felt,
    b: felt
}

fn main() -> felt {
    let es0 = MyEnumShort::a(10);
    match_short(es0)
}

fn match_short(e: MyEnumShort) -> felt {
    match e {
        MyEnumShort::a(x) => {
            x
        },
        MyEnumShort::b(x) => {
            x * 2
        },
    }
}
