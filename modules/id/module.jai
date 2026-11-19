#import "Extensions/Time";
#import "Basic";


#scope_export id_generator :: () -> string {
    instant, error := timestamp_now();
    assert(error.kind == .NONE);
    a := seconds_to_apollo(instant.seconds);
    ct := to_calendar(a);

    return sprint("%_%_%_%", ct.year, ct.month_starting_at_0, ct.day_of_month_starting_at_0, instant.nanoseconds);
}
