#import "Extensions/Time";
#import "Basic";
#import "POSIX";
#import "Random";

// Time function could be used later on

// #scope_export id_generator :: () -> string {
//     instant, error := timestamp_now();
//     assert(error.kind == .NONE);
//     a := seconds_to_apollo(instant.seconds);
//     ct := to_calendar(a);
//
//     return sprint("%_%_%_%", ct.year, ct.month_starting_at_0, ct.day_of_month_starting_at_0, instant.nanoseconds);
// }

#scope_export directory_parsing :: (path: string) -> [] string {
    sarr: [..] string;

    pdir: *DIR = opendir(to_c_string(path));
    if (!pdir) {
        print("[Error] Failed parsing tasks folder\n");
        exit(1);
    }
    entry: *dirent = readdir(pdir);
    while entry != null {
        s: string = to_string(entry.d_name);
        entry = readdir(pdir);
        if s == "." || s == ".." continue;
        array_add(*sarr, s);
    }

    return sarr;
}

#scope_export hex_gen :: (count: int) -> string {
    arr: [..] u8;
    defer array_free(arr);
    r: Random_State;
    instant, error := timestamp_now();
    assert(error.kind == .NONE);
    random_seed(*r, xx instant.nanoseconds);
    for 1..count {
        w: u8 = xx random_get_within_range(*r, 1, 36);
        if w <= 10 {
            w += 47;
        } else {
            w += 86;
        }
        array_add(*arr, w);
    }
    return to_string(arr);
}
