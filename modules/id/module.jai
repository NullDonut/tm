#import "Extensions/Time";
#import "Basic";
#import "POSIX";


#scope_export id_generator :: () -> string {
    instant, error := timestamp_now();
    assert(error.kind == .NONE);
    a := seconds_to_apollo(instant.seconds);
    ct := to_calendar(a);

    return sprint("%_%_%_%", ct.year, ct.month_starting_at_0, ct.day_of_month_starting_at_0, instant.nanoseconds);
}

#scope_export directory_parsing :: () -> [] string {
    sarr: [..] string;

    pdir: *DIR = opendir(".tasks");
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

    print("%\n", sarr);
    return sarr;
}

main :: () {
    directory_parsing();
}
