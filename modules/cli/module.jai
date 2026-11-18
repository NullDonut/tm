#import "Basic";

#scope_file cmd_help :: () {
    print("Unknown command\n");
    exit(0);
}

#scope_export cmd_parse_args :: (args: [] string) {
    if args.count <= 1 {
        cmd_help();
    }
    main_command_flag := args[1];
    print("% \n", main_command_flag);
    if main_command_flag == "add" {
        cmd_add(args);
    } else if main_command_flag == "list" {
        cmd_list();
    } else if main_command_flag == "skip" {
        cmd_skip();
    } else {
        cmd_help();
    }
}

#scope_file cmd_add :: (args: [] string) {
    if (args.count < 3) {
        print("Insufficient arguments\n");
        return;
    }
    for 2..args.count - 1 {
        print("Adding task: %\n", args[it]);
    }

    print("%\n", "[Info] Add mode");
}

#scope_file cmd_list :: () {
    print("%\n", "a");
}

#scope_file cmd_skip :: () {
    print("%\n", "s");
}
