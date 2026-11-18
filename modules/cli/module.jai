#import "Basic";

cmd_help :: () {
    print("Unknown command\n");
    exit(0);
}

cmd_parse_args :: (args: [] string) {
    if args.count <= 1 {
        cmd_help();
    }
    main_command_flag := args[1];
    print("% \n", main_command_flag);
    if main_command_flag == "add" {
        cmd_add();
    } else if main_command_flag == "list" {
        cmd_list();
    } else if main_command_flag == "skip" {
        cmd_skip();
    } else {
        cmd_help();
    }
}

cmd_add :: () {
    print("%\n", "h");
}

cmd_list :: () {
    print("%\n", "a");
}

cmd_skip :: () {
    print("%\n", "s");
}
