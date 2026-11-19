#import "Basic";
#import "cli";
#import "task";


main :: () {
    task_load();

    args: = get_command_line_arguments();
    cmd_parse_args(args);
}
